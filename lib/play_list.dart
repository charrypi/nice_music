import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nicemusic/common/playfunc.dart';
import 'package:nicemusic/components/list_more.dart';
import 'package:nicemusic/components/songlist_trailing.dart';
import 'package:nicemusic/db/playlist_dao.dart';
import 'package:nicemusic/components/empty_container.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/model/playlist_query.dart';
import 'package:provider/provider.dart';

import 'db/playlist_dao.dart';
import 'store/play_list_notifier.dart';

// 播放列表页面
class PlayList extends StatefulWidget {
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  // 是否全部加载完成
  bool isFinished = false;

  // 正在播放的歌曲id
  int pid;

  // 滑动控制器
  ScrollController _scrollCtl = ScrollController(keepScrollOffset: false);

  // 播放列表数据
  List<PlayListModel> playlist = List<PlayListModel>();

  // 列表查询对象
  PlayListQuery<PlayListModel> _playListQuery = PlayListQuery<PlayListModel>();

  @override
  void initState() {
    super.initState();
    _listenListScroll();
    _getDatas();
  }

  @override
  void dispose() {
    _scrollCtl.dispose();
    super.dispose();
  }

  // 列表滚动监听
  _listenListScroll() {
    _scrollCtl.addListener(() {
      if (_scrollCtl.position.pixels >= _scrollCtl.position.maxScrollExtent &&
          !isFinished) {
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollCtl,
          headerSliverBuilder: (context, _index) {
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
                      title:
                          Text('试听列表', style: TextStyle(color: Colors.white)),
                      background: Image.asset(
                        "icons/playlist_bg.jpg",
                        fit: BoxFit.fill,
                      )),
                  actions: <Widget>[
                    IconButton(
                        tooltip: '清空列表',
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Row(
                                  children: <Widget>[
                                    Icon(Icons.lightbulb_outline),
                                    Text('提醒')
                                  ],
                                ),
                                content: Text('确定清空试听列表吗?'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('取消'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                  FlatButton(
                                      child: Text('确定'),
                                      onPressed: () {
                                        _emptyPlayList().then((res) {
                                          Navigator.of(context).pop();
                                        });
                                      })
                                ],
                              ));
                        })
                  ])
            ];
          },
          body: _buildListView()),
    );
  }

  Widget _buildListView() {
    if (playlist.length == 0) {
      return EmptyContainer(
          assetName: 'icons/empty_list.svg', tips: '你还没有听过任何音乐哦');
    }
    return ListView.builder(
//        controller: _scrollCtl,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: playlist.length + 1,
        itemBuilder: (context, index) {
          if (index == playlist.length) {
            return ListMore(
              isEnd: isFinished,
            );
          }
          final music = playlist[index];
          return Container(
            child: InkWell(
              onTap: () {
                // 点击播放
                _searchAndPlay(music);
              },
              child: Slidable(
                key: Key(music.pid.toString()),
                closeOnScroll: true,
                actionPane: SlidableStrechActionPane(),
                child: ListTile(
                  leading: Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  title: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                        TextSpan(
                            text: music.sname, style: TextStyle(fontSize: 16)),
                        TextSpan(
                            text: '\t\t\t${music.source}',
                            style: TextStyle(fontSize: 12, color: Colors.blue))
                      ])),
                  subtitle: Text(_getSubTitle(music)),
                  trailing: _buildTrailing(music),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: '删除',
                      icon: Icons.delete,
                      color: Colors.redAccent,
                      onTap: () {
                        _removeListItem(music);
                      })
                ],
              ),
            ),
          );
        });
  }

  _getSubTitle(PlayListModel model) {
    String subTitle = model.artists;
    if (model.albumName != null && model.albumName.isNotEmpty) {
      subTitle += "－" + model.albumName;
    }
    return subTitle;
  }

  _buildTrailing(PlayListModel music) {
    return Container(
      width: 50,
      child: Row(
        children: <Widget>[
          _getTrailingWidget(music),
        ],
      ),
    );
  }

  _getTrailingWidget(PlayListModel music) {
    FavoriteModel favoriteModel = FavoriteModel(
        sid: music.sid,
        mid: music.mid,
        sname: music.sname,
        artists: music.artists,
        albumId: music.albumId,
        albumName: music.albumName,
        albumPic: music.albumPic,
        source: music.source);
    return SongListTrailing(music: favoriteModel, callback: null);
  }

  // 加载更多
  _loadMore() {
    if (playlist.length == _playListQuery.total) {
      isFinished = true;
      setState(() {});
      return;
    }
    _playListQuery.page++;
    _getDatas();
  }

  // 列表中移除
  _removeListItem(PlayListModel music) async {
    await _removeFromPlayList(music.pid);
    playlist
        .removeAt(playlist.indexWhere((element) => element.pid == music.pid));
    // 更新provider里的数据
    Provider.of<PlayListNotifier>(context, listen: false)
        .updatePlayList(playlist);
    setState(() {});
  }

  // 获取分页数据
  _getDatas() async {
    _playListQuery = await queryPlayList(_playListQuery);
    playlist.addAll(_playListQuery.result);
    if (_playListQuery.total == playlist.length) {
      this.isFinished = true;
    }
    setState(() {});
  }

  // 删除数据库中的数据
  Future _removeFromPlayList(int pid) async {
    return await removePlayListByPid(pid: pid);
  }

  // 搜索并播放
  _searchAndPlay(PlayListModel model) async {
    playInPlayList(model);
  }

  // 清空列表
  _emptyPlayList() async {
    playlist.clear();
    return await emptyPlayList().then((resp) {
      Provider.of<PlayListNotifier>(context, listen: false).updatePlayList([]);
      setState(() {});
    });
  }
}
