import 'package:flutter/material.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/store/favorite_list_notifier.dart';
import 'package:nicemusic/common/downloadfunc.dart';
import 'package:provider/provider.dart';

/// 搜索列表条目后缀-收藏功能组件
class SongListTrailing extends StatefulWidget {
  final FavoriteModel music;
  final callback;

  SongListTrailing({this.music, this.callback});

  @override
  _SongListTrailingState createState() => _SongListTrailingState();
}

class _SongListTrailingState extends State<SongListTrailing> {
  // 是否存在收藏列表中
  bool exist = false;

  @override
  Widget build(BuildContext context) {
    exist = Provider.of<FavoriteListNotifier>(context)
        .checkExist(sid: widget.music.sid, source: widget.music.source);
    return Container(
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Icon(exist ? Icons.favorite : Icons.favorite_border,
                  color: exist ? Colors.red : null),
              onTap: () {
                if (exist) {
                  // 移除收藏
                  _removeFavorite();
                } else {
                  // 添加收藏
                  _saveFavorite();
                }
              },
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Icon(Icons.file_download),
              onTap: () {
                _download();
              },
            )
          ],
        ));
  }

  // 保存收藏歌曲到数据库
  _saveFavorite() async {
    Provider.of<FavoriteListNotifier>(context, listen: false).add(widget.music);
  }

  // 从收藏中移除
  _removeFavorite() {
    Provider.of<FavoriteListNotifier>(context, listen: false)
        .remove(sid: widget.music.sid, source: widget.music.source);
  }

  _download() async {
    DownloadListModel downloadModel = DownloadListModel(
        sid: widget.music.sid,
        mid: widget.music.mid,
        sname: widget.music.sname,
        artists: widget.music.artists,
        albumId: widget.music.albumId,
        albumPic: widget.music.albumPic,
        albumName: widget.music.albumName,
        source: widget.music.source);
    download(downloadModel);
  }
}
