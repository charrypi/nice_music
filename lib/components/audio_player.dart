import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:headset_event/headset_event.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/db/playlist_dao.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/event/player_state_event.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/model/playlist_query.dart';
import 'package:nicemusic/play_view.dart';
import 'package:nicemusic/store/play_list_notifier.dart';
import 'package:nicemusic/store/player_state_notifier.dart';
import 'package:nicemusic/store/playmode_notifier.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';

enum PlayerState { stopped, playing, paused }

/// 音乐播放器
class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer player;
  Duration _duration;
  Duration _position;

  AudioPlayerState _audioPlayerState;

  PlayerState _playerState = PlayerState.stopped;

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;

  PlayerProperties _playerProperties = PlayerProperties();

  // 当前播放音乐在播放列表中的主键
  int _pid;

  PlayerStateEnum _playerStateEnum = PlayerStateEnum.PREPARE;

  // 头戴设备状态监测
  HeadsetEvent headsetPlugin = new HeadsetEvent();

  // 是否是本地播放
  bool _isLocal = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
    _initEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5),
        alignment: Alignment.center,
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                width: 45,
                height: 45,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                      imageErrorBuilder: (BuildContext context, Object error,
                          StackTrace stackTrace) {
                        return Image.asset('icons/default_album.jpg');
                      },
                      placeholder: "icons/default_album.jpg",
                      image: _playerProperties.albumPicUrl == null
                          ? 'icons/default_album.jpg'
                          : _playerProperties.albumPicUrl),
                ),
              ),
              onTap: _playerProperties.sid == null
                  ? null
                  : () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PlayView();
                      }))),
          Container(
            margin: EdgeInsets.only(left: 5),
            height: 40,
            width: 180,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _descriptionPanel(),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: SvgPicture.asset(
                  "icons/rewind.svg",
                  width: 40,
                ),
                onTap: this._playerProperties.url == null
                    ? null
                    : () {
                        _previousSong();
                      },
              ),
              CircularPercentIndicator(
                  radius: 35,
                  lineWidth: 1,
                  animationDuration: 0,
                  percent: (_position != null &&
                          _duration != null &&
                          _position.inMilliseconds > 0 &&
                          _position.inMilliseconds < _duration.inMilliseconds)
                      ? _position.inMilliseconds / _duration.inMilliseconds
                      : 0.0,
                  center: Container(
                      width: 41,
                      height: 41,
                      child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          child: _isPlaying
                              ? SvgPicture.asset("icons/play.svg", width: 40)
                              : SvgPicture.asset("icons/pause.svg", width: 40),
                          onTap: this._playerProperties.url == null
                              ? null
                              : () {
                                  if (_isPlaying) {
                                    _pause();
                                  } else if (_isPaused) {
                                    _resume();
                                  }
                                }))),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: SvgPicture.asset("icons/fast_forward.svg", width: 40),
                onTap: this._playerProperties.url == null
                    ? null
                    : () {
                        this._nextSong();
                      },
              ),
            ],
          ))
        ]));
  }

  _descriptionPanel() {
    if (_playerStateEnum == PlayerStateEnum.PREPARE ||
        _playerStateEnum == PlayerStateEnum.DONE) {
      return [
        Text(
          this._playerProperties.songName,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          this._playerProperties.albumName,
          style: TextStyle(fontSize: 12, color: Colors.black45),
          overflow: TextOverflow.ellipsis,
        )
      ];
    } else if (_playerStateEnum == PlayerStateEnum.CONNECTING) {
      return [Container(child: Text('正在连接中...'))];
    } else if (_playerStateEnum == PlayerStateEnum.ERROR) {
      // 还原显示
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          _playerStateEnum = PlayerStateEnum.DONE;
        });
      });
      return [Container(child: Text('播放失败'))];
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
  }

  // 播放
  Future _play() async {
    var result = -1;
    try {
      result = await player.play(this._playerProperties.url,
          isLocal: this._isLocal, stayAwake: true);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          '播放异常',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    Provider.of<PlayerPropertiesNotifier>(context, listen: false)
        .updatePlayerProperties(this._playerProperties);
    if (result == 1) {
      // 立即更新时间轴，防止网络问题延迟播放依然显示上次的播放时间点
      setState(() {
        _position = _duration = Duration(milliseconds: 0);
        _playerStateEnum = PlayerStateEnum.DONE;
        _playerState = PlayerState.playing;
      });
      Provider.of<PlayerStateNotifier>(context, listen: false)
          .setDuration(_duration);
      Provider.of<PlayerStateNotifier>(context, listen: false)
          .setPosition(_position);
    }
    return result;
  }

  // 恢复
  Future _resume() async {
    var result = await player.resume();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.playing;
      });
    }
  }

  // 暂停
  Future _pause() async {
    final result = await player.pause();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.paused;
      });
    }
    return result;
  }

  // 停止
//  Future _stop() async {
//    return await player.stop();
//  }

  // 跳转到指定时间
  Future _seek(Duration position) async {
    return await player.seek(position);
  }

  // 初始化播放器
  _initPlayer() {
    AudioPlayer.logEnabled = false;
    player = AudioPlayer();
    _durationSubscription = player.onDurationChanged.listen((duration) {
      Provider.of<PlayerStateNotifier>(context, listen: false)
          .setDuration(duration);
      setState(() {
        _duration = duration;
      });
    });
    //    player.setNotification()
    _positionSubscription = player.onAudioPositionChanged.listen((position) {
      Provider.of<PlayerStateNotifier>(context, listen: false)
          .setPosition(position);
      setState(() {
        _position = position;
      });
    });

    _playerCompleteSubscription = player.onPlayerCompletion.listen((event) {
      _onComplete();
    });

    _playerStateSubscription = player.onPlayerStateChanged.listen((state) {
      Provider.of<PlayerStateNotifier>(context, listen: false)
          .changePlayerState(state);
      setState(() {
        _audioPlayerState = state;
      });
    });

    _playerErrorSubscription = player.onPlayerError.listen((msg) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          '播放异常',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    });
  }

  // 初始化事件监听
  _initEvent() {
    eventBus.on<PlayerEvent>().listen((event) {
      if (event.playerProperties != null) {
        if (event.playerProperties.url == null ||
            event.playerProperties.url.isEmpty) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              '获取不到音乐地址，无法播放',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
          setState(() {
            _playerStateEnum = PlayerStateEnum.DONE;
          });
          return;
        }
        this._playerProperties = event.playerProperties;
      }
      switch (event.cmd) {
        case PlayerCmd.PLAY:
          this._isLocal = event.playerProperties.isLocal;
          this._pid = event.pid;
          if (!this._isLocal) {
            // 生成播放列表
            _updatePlayList();
          }
          _play();
          break;
        case PlayerCmd.PAUSE:
          _pause();
          break;
        case PlayerCmd.SEEK:
          if (event.duration != null) {
            _seek(event.duration);
          }
          break;
        case PlayerCmd.NEXT:
          _nextSong();
          break;
        case PlayerCmd.FORWARD:
          _previousSong();
          break;
        case PlayerCmd.STOP:
          break;
        case PlayerCmd.RESUME:
          break;
      }
    });

    eventBus.on<PlayerStateEvent>().listen((event) {
      setState(() {
        _playerStateEnum = event.state;
      });
    });

    // 头戴设备状态监听
    headsetPlugin.setListener((payload) {
      if (payload == HeadsetState.DISCONNECT) {
        _pause();
      } else if (payload == HeadsetState.CONNECT) {
        _play();
      } else if (payload == HeadsetState.NEXT) {
        _nextSong();
      } else if (payload == HeadsetState.PREV) {
        _previousSong();
      }
    });
  }

  // 播放完成之后的操作
  _onComplete() {
    PlayMode playMode =
        Provider.of<PlayModeNotifier>(context, listen: false).playMode;
    switch (playMode) {
      case PlayMode.SINGLE_LOOP:
        _play();
        break;
      case PlayMode.LIST_LOOP:
        _nextSong();
        break;
      case PlayMode.RANDOM_LOOP:
        _randomSong();
        break;
    }
  }

  // 随机下一首
  _randomSong() {
    List<PlayListModel> list =
        Provider.of<PlayListNotifier>(context, listen: false).playList;
    if (list == null || list.isEmpty || list.length == 1) {
      // // 继续播放当前音乐
      eventBus.fire(PlayerEvent(
          cmd: PlayerCmd.PLAY,
          pid: this._pid,
          playerProperties: this._playerProperties));
      return;
    }
    PlayListModel nextSong = _getRandomSong(list);
    this._pid = nextSong.pid;
    _playSong(nextSong, _randomSong);
  }

  // 获取随机歌曲
  _getRandomSong(List<PlayListModel> list) {
    int index = Random().nextInt(list.length);
    PlayListModel nextSong = list[index];
    // 避免下一首依然是当前播放的
    if (this._pid == nextSong.pid) {
      return _getRandomSong(list);
    }
    return nextSong;
  }

  // 更新播放列表
  _updatePlayList() async {
    PlayListQuery query = PlayListQuery();
    query.rows = -1;
    query = await queryPlayList(query);
    List<PlayListModel> list = query.result;
    Provider.of<PlayListNotifier>(context, listen: false).updatePlayList(list);
  }

  // 下一首
  _nextSong() {
    List<PlayListModel> list =
        Provider.of<PlayListNotifier>(context, listen: false).playList;
    if (list == null || list.isEmpty) {
      // 继续播放当前音乐
      eventBus.fire(PlayerEvent(
          cmd: PlayerCmd.PLAY,
          pid: this._pid,
          playerProperties: this._playerProperties));
      return;
    }
    int index = list.indexWhere((model) => model.pid == this._pid);
    PlayListModel nextSong;
    if (index == list.length - 1) {
      index = 0;
    } else {
      index++;
    }
    nextSong = list[index];
    this._pid = nextSong.pid;
    _playSong(nextSong, _nextSong);
  }

  // 上一首
  _previousSong() {
    List<PlayListModel> list =
        Provider.of<PlayListNotifier>(context, listen: false).playList;
    if (list == null || list.isEmpty) {
      // 继续播放当前音乐
      eventBus.fire(PlayerEvent(
          cmd: PlayerCmd.PLAY,
          pid: this._pid,
          playerProperties: this._playerProperties));
      return;
    }
    int index = list.indexWhere((model) => model.pid == this._pid);
    PlayListModel previousSong;
    if (index == 0) {
      index = list.length - 1;
    } else {
      index--;
    }
    previousSong = list[index];
    this._pid = previousSong.pid;
    _playSong(previousSong, _previousSong);
  }

  // 根据已有播放信息播放
  _playSong(PlayListModel model, Function func, {int retry = 0}) async {
    // 重试达到一定次数执行下一次操作
    if (retry >= 3) {
      func();
      return;
    }
    try {
      PlatformApi api = MusicPlatforms.get(model.source).api;
      final query = {
        'id': model.sid,
        'mid': model.mid,
        'albumId': model.albumId
      };
      PlayerProperties playerProperties = PlayerProperties();
      // 如果原播放属性为本地播放，当前上/下一首也跟随当前播放属性
      if (_playerProperties.isLocal) {
        playerProperties.isLocal = true;
      }
      playerProperties.sid = model.sid;
      playerProperties.source = model.source;
      playerProperties.mid = model.mid;
      playerProperties.songName = model.sname;
      playerProperties.albumId = model.albumId;
      playerProperties.albumName = model.albumName;
      playerProperties.artists = model.artists;
      String playUrl = await api.getPlayUrl(query);
      playerProperties.url = playUrl;
      String albumPic = await api.getAlbumPic(query);
      playerProperties.albumPicUrl = albumPic;
      String lyric = await api.getLyric(query);
      playerProperties.lyric = lyric;
      this._playerProperties = playerProperties;
      // 播放
      _play();
    } catch (e) {
      _playSong(model, func, retry: ++retry);
    }
  }
}
