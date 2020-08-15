import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/components/empty_container.dart';
import 'package:nicemusic/db/downloadlist_dao.dart';
import 'package:nicemusic/event/download_completed_event.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/event/player_state_event.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/downloadlist_query.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/store/play_list_notifier.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';
import 'package:nicemusic/store/playmode_notifier.dart';
import 'package:provider/provider.dart';

// 已完成下载列表
class DownloadedListView extends StatefulWidget {
  @override
  _DownloadedListState createState() => _DownloadedListState();
}

class _DownloadedListState extends State<DownloadedListView>
    with AutomaticKeepAliveClientMixin {
  List<DownloadListModel> datas = List<DownloadListModel>();

  @override
  void initState() {
    super.initState();
    _initData();
    _initEvent();
  }

  _initData() async {
    DownloadListQuery query = DownloadListQuery();
    query.rows = -1;
    query = await queryDownloadList(query);
    if (mounted) {
      datas = query.result;
      setState(() {});
    }
  }

  _initEvent() {
    eventBus.on<DownLoadCompletedEvent>().listen((event) {
      _initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (datas.length == 0) {
      return EmptyContainer(
          assetName: 'icons/cute_pumpkin.svg', tips: '你还没有下载任何音乐哦');
    }
    return ListView.builder(
        itemCount: datas.length,
        cacheExtent: 10,
        itemBuilder: (context, index) {
          DownloadListModel model = datas[index];
          return Slidable(
            key: Key(model.did.toString()),
            actionPane: SlidableScrollActionPane(),
            closeOnScroll: true,
            child: ListTile(
                title: Text(model.sname),
                subtitle: Text(model.artists),
                leading: SvgPicture.asset('icons/music.svg', width: 25),
                trailing: Text(
                    (model.fileSize / 1024 / 1024).toStringAsFixed(2) + 'M'),
                onTap: () {
                  _playLocal(model);
                }),
            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: '删除',
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onTap: () {
                    _removeListItem(model);
                  })
            ],
          );
        });
  }

  void _removeListItem(DownloadListModel model) async {
    // 删除列表数据
    await removeDownloadList(model);
    datas.removeAt(datas.indexWhere((element) => element.did == model.did));
    if (model.localPath != null) {
      // 删除本地文件
      File file = File(model.localPath);
      if (await file.exists()) {
        file.delete();
      }
    }
    setState(() {});
  }

  void _playLocal(DownloadListModel model) async {
    File file = File(model.localPath);
    if (!await file.exists()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          '文件不存在！',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.CONNECTING));
    Provider.of<PlayModeNotifier>(context, listen: false)
        .changePlayMode(PlayMode.SINGLE_LOOP);
    List<PlayListModel> playList = List();
    playList.add(PlayListModel.fromJson(model.toJson()));
    Provider.of<PlayListNotifier>(context, listen: false)
        .updatePlayList(playList);
    eventBus.fire(PlayerEvent(
        cmd: PlayerCmd.PLAY,
        playerProperties: PlayerProperties(
            isLocal: true,
            sid: model.sid,
            mid: model.mid,
            albumId: model.albumId,
            source: model.source,
            artists: model.artists,
            url: model.localPath,
            songName: model.sname,
            albumName: model.albumName,
            albumPicUrl: model.albumPic)));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
