import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/components/song_list_contaner.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/model/wy/wy_music_model.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/event/player_state_event.dart';
import 'package:nicemusic/model/song_query.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/components/songlist_trailing.dart';
import 'package:nicemusic/components/empty_container.dart';
import 'package:nicemusic/components/list_more.dart';
import 'package:nicemusic/db/playlist_dao.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';

// 网易歌曲列表组件
class WySongList extends StatefulWidget implements SongListContainer {
  final PlatformApi api;

  WySongList({this.api}) : super();

  final WySongListState wySongListState = WySongListState();

  @override
  WySongListState createState() => wySongListState;

  @override
  void onQuery(String query) {
    if (query == null || query.isEmpty) return;
    wySongListState.query(query);
  }
}

class WySongListState extends State<WySongList>
    with AutomaticKeepAliveClientMixin {
  // 加载更多状态
  bool isFinished = false;

  // 正在播放的歌曲id
  int playingId;

  // 歌曲列表
  final List<Songs> musics = List<Songs>();

  String queryStr;

  ScrollController _scrollCtl = ScrollController();

  SongQuery songQuery = SongQuery(conditions: Map());

  query(String query) {
    if (this.queryStr == query) return;
    print('网易查询：$query');
    this.queryStr = query;
    songQuery.page = 1;
    Map<String, dynamic> conditions = {
      's': query,
      'type': 1,
      'limit': 10,
      'offset': (songQuery.page - 1) * songQuery.rows
    };
    songQuery.conditions = conditions;
    // 清空数据
    setState(() {
      musics.clear();
    });
    // 获取数据
    _getDatas();
  }

  @override
  void initState() {
    super.initState();
    _listenListScroll();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollCtl.dispose();
  }

  // 滚动监听
  void _listenListScroll() {
    _scrollCtl.addListener(() {
      if (_scrollCtl.position.pixels >= _scrollCtl.position.maxScrollExtent &&
          !isFinished) {
        // 加载更多
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (musics.length == 0) {
      return EmptyContainer(
          assetName: 'icons/empty_list2.svg', tips: '列表是空的~_~');
    }
    return ListView.builder(
        controller: _scrollCtl,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == musics.length) {
            return ListMore(
              isEnd: isFinished,
            );
          }
          final music = musics[index];
          return Container(
            padding: EdgeInsets.only(left: 1),
            child: Material(
                child: InkWell(child: _buildListItem(context, music, index))),
          );
        },
        itemCount: musics.length + 1,
        cacheExtent: 10);
  }

  Widget _buildListItem(BuildContext context, Songs music, int index) {
//    bool isPlaying = playingId == music.id;
    bool isPlaying = false;
    return ListTile(
      title: _buildListItemTitle(music),
      leading: _buildListLeading(index, isPlaying),
      subtitle: Text(_getSubTitle(music), style: TextStyle(fontSize: 12)),
      trailing: _getTrailingWidget(music),
      onTap: () {
        _playSong(music).then((value) {
          setState(() {
            playingId = music.id;
          });
        });
      },
    );
  }

  Widget _buildListLeading(int index, bool isPlaying) {
    return Container(
        width: 30,
        alignment: Alignment.center,
        child: isPlaying
            ? SvgPicture.asset('icons/deezer.svg')
            : Text((index + 1).toString()));
  }

  _getTrailingWidget(Songs music) {
    FavoriteModel favoriteModel = FavoriteModel(
        sid: music.id,
        mid: music.id.toString(),
        sname: music.name,
        artists: _getArtists(music)?.join('&'),
        albumId: music.album.id.toString(),
        albumName: music.album.name,
        source: MusicPlatforms.wy.code);
    return SongListTrailing(music: favoriteModel, callback: null);
  }

  // 获取歌手信息
  List<String> _getArtists(Songs music) {
    List<String> artists = List();
    if (music.artists != null) {
      music.artists.forEach((artist) {
        artists.add(artist.name);
      });
    }
    return artists;
  }

  // 获取副标题
  String _getSubTitle(Songs music) {
    String subTitle = "";
    List<String> artists = _getArtists(music);
    subTitle += artists?.join("&");
    if (music.album != null && music.album.name.isNotEmpty) {
      subTitle += "－" + music.album.name;
    }
    return subTitle.toString();
  }

  // 构造ListItem title组件
  Widget _buildListItemTitle(Songs music) {
    return Align(
        child: Text(music.name,
            style: TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        alignment: Alignment.centerLeft);
  }

  // 远程搜索歌曲并播放
  Future _playSong(Songs music) async {
    try {
      eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.CONNECTING));
      int id = music.id;
      PlayerProperties playerProperties = PlayerProperties();
      playerProperties.isLocal = false;
      playerProperties.sid = id;
      playerProperties.source = MusicPlatforms.wy.code;
      playerProperties.mid = id.toString();
      playerProperties.albumId = music.album.id.toString();
      playerProperties.songName = music.name;
      playerProperties.albumName = music.album.name;
      playerProperties.artists = _getArtists(music)?.join('&');
      final query = {'id': id};
      String playUrl = await widget.api.getPlayUrl(query);
      playerProperties.url = playUrl;
      String albumPic = await widget.api.getAlbumPic(query);
      playerProperties.albumPicUrl = albumPic;
      String lyric = await widget.api.getLyric(query);
      playerProperties.lyric = lyric;

      checkPlayListExist(sid: id, source: MusicPlatforms.wy.code).then((pid) {
        if (pid == null) {
          // 添加到播放列表
          PlayListModel data = PlayListModel(
              sid: id,
              mid: id.toString(),
              sname: music.name,
              artists: _getArtists(music) != null
                  ? _getArtists(music).join('&')
                  : '',
              albumId: music.album.id.toString(),
              albumName: music.album?.name,
              albumPic: playerProperties.albumPicUrl,
              source: MusicPlatforms.wy.code);
          return saveToPlayList(data.toJson());
        } else {
          return pid;
        }
      }).then((pid) {
        // 触发播放
        eventBus.fire(PlayerEvent(
            cmd: PlayerCmd.PLAY, pid: pid, playerProperties: playerProperties));
      });
    } catch (e) {
      eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.ERROR));
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            '获取歌曲信息失败',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red));
    }
  }

  // 加载更多
  _loadMore() {
    if (musics.length == songQuery.total) {
      this.isFinished = true;
      setState(() {});
      return;
    }
    songQuery.page++;
    songQuery.conditions['offset'] = (songQuery.page - 1) * songQuery.rows;
    _getDatas();
  }

  // 异步获取数据
  _getDatas() async {
    WyMusicModel model = await widget.api.getPageList(songQuery);
    songQuery.total = model.result.songCount;
    musics.addAll(model.result.songs);
    // 此处判断特殊，存在songCount！= songs.length的情况
    if (!model.result.hasMore) {
      this.isFinished = true;
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
