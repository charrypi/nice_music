import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/components/empty_container.dart';
import 'package:nicemusic/components/list_more.dart';
import 'package:nicemusic/components/song_list_contaner.dart';
import 'package:nicemusic/components/songlist_trailing.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/db/playlist_dao.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/event/player_state_event.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/model/kw/kw_music_list.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/model/song_query.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';

// 酷我歌曲列表组件
class KwSongList extends StatefulWidget implements SongListContainer {
  final PlatformApi api;

  KwSongList({this.api}) : super();

  final KwSongListState kwSongListState = KwSongListState();

  @override
  KwSongListState createState() => kwSongListState;

  @override
  void onQuery(String queryStr) {
    if (queryStr != null && queryStr.isNotEmpty) {
      kwSongListState.query(queryStr);
    }
  }
}

class KwSongListState extends State<KwSongList>
    with AutomaticKeepAliveClientMixin {
  // 加载更多状态
  bool isFinished = false;

  // 正在播放的歌曲id
  int playingId;

  // 歌曲列表
  List<Abslist> songs = List();

  ScrollController _scrollCtl = ScrollController();

  // 查询器
  SongQuery songQuery = SongQuery(conditions: Map());

  // 查询的字符串
  String queryStr;

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
    if (songs.length == 0) {
      return EmptyContainer(
          assetName: 'icons/empty_list2.svg', tips: '列表是空的~_~');
    }
    return ListView.builder(
        controller: _scrollCtl,
        physics: AlwaysScrollableScrollPhysics(),
        cacheExtent: 10,
        itemCount: songs.length + 1,
        itemBuilder: (context, index) {
          if (index == songs.length) {
            return ListMore(
              isEnd: isFinished,
            );
          }
          final music = songs[index];
          return Container(
            padding: EdgeInsets.only(left: 1),
            child: Material(
                child: InkWell(child: _buildListItem(context, music, index))),
          );
        });
  }

  Widget _buildListItem(BuildContext context, Abslist music, int index) {
//    bool isPlaying = playingId == music.AL;
    bool isPlaying = false;
    return ListTile(
      title: _buildListItemTitle(music),
      leading: _buildListLeading(index, isPlaying),
      subtitle: Text(_getSubTitle(music), style: TextStyle(fontSize: 12)),
      trailing: _getTrailingWidget(music),
      onTap: () {
        _playSong(music).then((value) {
//          setState(() {
//            playingId = music.id;
//          });
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

  _getTrailingWidget(Abslist music) {
    FavoriteModel favoriteModel = FavoriteModel(
        sid: int.parse(music.MUSICRID.replaceAll('MUSIC_', '')),
        mid: music.MUSICRID.replaceAll('MUSIC_', ''),
        sname: music.SONGNAME,
        artists: music.ARTIST,
        albumId: music.ALBUMID,
        albumName: music.ALBUM,
        source: MusicPlatforms.kw.code);
    return SongListTrailing(music: favoriteModel, callback: null);
  }

  // 获取副标题
  String _getSubTitle(Abslist music) {
    String subTitle = "${music.ARTIST}";
    if (music.ALBUM != null && music.ALBUM.isNotEmpty) {
      subTitle += "－" + music.ALBUM;
    }
    return subTitle.toString();
  }

  // 构造ListItem title组件
  Widget _buildListItemTitle(Abslist music) {
    return Align(
        child: Text(music.SONGNAME,
            style: TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        alignment: Alignment.centerLeft);
  }

  query(String query) {
    if (this.queryStr == query) return;
    print('kw搜索：$query');
    this.queryStr = query;
    songQuery.page = 1;
    Map<String, dynamic> conditions = {'queryStr': query};
    songQuery.conditions = conditions;
    setState(() {
      songs.clear();
    });
    _getDatas();
  }

  _getDatas() async {
    KwMusicList list = await widget.api.getPageList(songQuery);
    songQuery.total = int.parse(list.TOTAL);
    songs.addAll(list.abslist);
    if (songs.length == songQuery.total) {
      this.isFinished = true;
    }
    setState(() {});
  }

  // 加载更多
  void _loadMore() {
    if (songs.length == songQuery.total) {
      this.isFinished = true;
      setState(() {});
      return;
    }
    songQuery.page++;
    _getDatas();
  }

  // 播放歌曲
  _playSong(Abslist music) async {
    try {
      eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.CONNECTING));
      String id = music.MUSICRID.replaceAll('MUSIC_', '');
      PlayerProperties playerProperties = PlayerProperties();
      playerProperties.isLocal = false;
      playerProperties.sid = int.parse(id);
      playerProperties.source = MusicPlatforms.kw.code;
      playerProperties.mid = id;
      playerProperties.albumId = music.ALBUMID;
      playerProperties.songName = music.SONGNAME;
      playerProperties.albumName = music.ALBUM;
      playerProperties.artists = music.ARTIST;
      Map<String, dynamic> params = {'id': id};
      String playUrl = await widget.api.getPlayUrl(params);
      playerProperties.url = playUrl;
      String albumPic = await widget.api.getAlbumPic(params);
      playerProperties.albumPicUrl = albumPic;
      String lyric = await widget.api.getLyric(params);
      playerProperties.lyric = lyric;

      checkPlayListExist(sid: id, source: MusicPlatforms.kw.code).then((pid) {
        if (pid == null) {
          // 添加到播放列表
          PlayListModel data = PlayListModel(
              sid: int.parse(id),
              mid: id,
              sname: music.SONGNAME,
              artists: music.ARTIST,
              albumId: music.ALBUMID,
              albumName: music.ALBUM,
              albumPic: playerProperties.albumPicUrl,
              source: MusicPlatforms.kw.code);
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

  @override
  bool get wantKeepAlive => true;
}
