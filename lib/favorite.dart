import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/components/list_more.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/db/favorite_dao.dart';
import 'package:nicemusic/db/playlist_dao.dart';
import 'package:nicemusic/model/favorite_query.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/components/empty_container.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/event/player_state_event.dart';
import 'package:nicemusic/store/favorite_list_notifier.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';
import 'package:provider/provider.dart';

// 收藏列表页面
class FavoriteList extends StatefulWidget {
  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  // 收藏列表
  List<FavoriteModel> favorites = List<FavoriteModel>();

  FavoriteQuery<FavoriteModel> favoriteQuery = FavoriteQuery<FavoriteModel>();

  ScrollController _scrollCtl = ScrollController();

  // 是否全部加载完成
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _listenListScroll();
    _getFavorites();
  }

  @override
  void dispose() {
    _scrollCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollCtl,
          headerSliverBuilder: (context, scrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                expandedHeight: 100,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text('收藏列表', style: TextStyle(color: Colors.white)),
                    background: Image.asset(
                      "icons/favorite_bg.jpg",
                      fit: BoxFit.fill,
                    )),
              )
            ];
          },
          body: _buildListView()),
    );
  }

  Widget _buildListView() {
    if (favorites.length == 0) {
      return EmptyContainer(
          assetName: 'icons/empty_list.svg', tips: '你还没有收藏任何音乐哦');
    }
    return ListView.builder(
        controller: _scrollCtl,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: favorites.length + 1,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          if (index == favorites.length) {
            return ListMore(isEnd: isFinished);
          }
          final model = favorites[index];
          return Material(
            child: InkWell(
              onTap: () {
                // 点击直接播放
                _searchAndPlay(model, context);
              },
              child: Slidable(
                  key: Key(model.fid.toString()),
                  closeOnScroll: true,
                  actionPane: SlidableStrechActionPane(),
                  child: ListTile(
                    leading: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text((index + 1).toString(),
                            style: TextStyle(fontSize: 18))),
                    title: Text(model.sname),
                    subtitle: Text(_getSubTitle(model)),
                    trailing: Text('来源:${model.source}',
                        style: TextStyle(color: Colors.black12)),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '删除',
                      icon: Icons.delete,
                      color: Colors.redAccent,
                      onTap: () {
                        _removeListItem(model);
                      },
                    )
                  ]),
            ),
          );
        });
  }

  // 从列表中移除item
  _removeListItem(FavoriteModel model) {
    Provider.of<FavoriteListNotifier>(context, listen: false)
        .remove(sid: model.sid, source: model.source);
    // 从列表中移除
    setState(() {
      favorites.removeAt(favorites.indexWhere((el) => el.fid == model.fid));
    });
  }

  _getSubTitle(FavoriteModel model) {
    String subTitle = model.artists;
    if (model.albumName != null && model.albumName.isNotEmpty) {
      subTitle += "－" + model.albumName;
    }
    return subTitle;
  }

  // 获取收藏列表
  _getFavorites() async {
    favoriteQuery = await queryFavoriteList(favoriteQuery);
    favorites.addAll(favoriteQuery.result);
    if (favoriteQuery.total == favorites.length) {
      this.isFinished = true;
    }
    setState(() {});
  }

  // 远程搜索歌曲url地址
  Future<void> _searchAndPlay(FavoriteModel model, BuildContext context) async {
    try {
      eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.CONNECTING));
      PlatformApi api = MusicPlatforms.get(model.source).api;
      final query = {
        'id': model.sid,
        'mid': model.mid,
        'albumId': model.albumId
      };
      PlayerProperties playerProperties = PlayerProperties();
      playerProperties.isLocal = false;
      playerProperties.sid = model.sid;
      playerProperties.source = model.source;
      playerProperties.mid = model.mid;
      playerProperties.songName = model.sname;
      playerProperties.albumName = model.albumName;
      playerProperties.albumId = model.albumId;
      playerProperties.artists = model.artists;
      String playUrl = await api.getPlayUrl(query);
      playerProperties.url = playUrl;
      String albumPic = await api.getAlbumPic(query);
      playerProperties.albumPicUrl = albumPic;
      String lyric = await api.getLyric(query);
      playerProperties.lyric = lyric;

      checkPlayListExist(sid: model.sid, source: MusicPlatforms.wy.code)
          .then((pid) {
        if (pid == null) {
          // 添加到播放列表
          PlayListModel data = PlayListModel(
              sid: model.sid,
              mid: model.mid,
              sname: model.sname,
              artists: model.artists,
              albumId: model.albumId,
              albumName: model.albumName,
              albumPic: playerProperties.albumPicUrl,
              source: model.source);
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

  // 监听列表滚动
  _listenListScroll() {
    _scrollCtl.addListener(() {
      if (_scrollCtl.position.pixels >= _scrollCtl.position.maxScrollExtent &&
          !this.isFinished) {
        // 加载更多
        _loadMore();
      }
    });
  }

  // 加载更多
  _loadMore() async {
    if (favorites.length == favoriteQuery.total) {
      isFinished = true;
      setState(() {});
      return;
    }
    favoriteQuery.page++;
    _getFavorites();
  }
}
