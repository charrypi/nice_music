import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/components/lyric/lyric_entry.dart';
import 'package:nicemusic/components/lyric/lyric_view.dart';
import 'package:nicemusic/components/playview/play_view_bottom_buttons.dart';
import 'package:nicemusic/components/playview/player_slider.dart';
import 'package:nicemusic/components/playview/album_rotation.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/store/favorite_list_notifier.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';
import 'package:nicemusic/common/downloadfunc.dart';
import 'package:provider/provider.dart';

// 播放器详情页面
class PlayView extends StatefulWidget {
  @override
  _PlayViewState createState() => _PlayViewState();
}

enum _FuncValue { F1 }

class _PlayViewState extends State<PlayView> {
  PlayerProperties _playerProperties;

  ImageProvider get _albumPic =>
      _playerProperties == null || _playerProperties.albumPicUrl == null
          ? AssetImage('icons/default_album.jpg')
          : NetworkImage(_playerProperties.albumPicUrl);

  @override
  void initState() {
    super.initState();
  }

  // 构建歌词数据
  _buildLyricData() {
    // 歌词数据
    List<LyricEntry> lyrics = List<LyricEntry>();
    String lyricStr = _playerProperties.lyric;
    try {
      if (lyricStr == null || lyricStr.isEmpty) {
        return lyrics;
      }
      List<String> lyricContents = lyricStr.trim().split(RegExp('\n'));
      lyricContents.forEach((lyric) {
        String time = '00:00.00';
        String content = "";
        String t = lyric.substring(lyric.indexOf('[') + 1, lyric.indexOf(']'));
        List<String> tr = t.split(':');
        // 判断是否为数字
        if (_isNumber(tr[0])) {
          // 是数字
          time = t;
          content = lyric.split(RegExp(']'))[1];
        } else {
          content = t;
        }
        lyrics
            .add(LyricEntry(time: parse2milliseconds(time), content: content));
      });
    } catch (e, s) {
      print(s);
//      if (lyricStr != null && lyricStr.isNotEmpty) {
//        List<String> lyricContents = lyricStr.trim().split(RegExp('\n'));
//        lyricContents.forEach((lyric) {
//          // 不支持滚动的歌词
//          lyrics.add(LyricEntry(time: -1, content: lyricStr));
//        });
//      }
    }
    return lyrics;
  }

  // 判断字符串是否是数字
  _isNumber(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  /// 时间字符串转毫秒数
  /// str格式 01:05.97
  int parse2milliseconds(String str) {
    List<String> strList = str.split(':');
    int minutes = int.parse(strList[0]);
    List<String> strList2 = strList[1].split('.');
    int seconds = int.parse(strList2[0]);
    int milliseconds = int.parse(strList2[1]);
    return minutes * 60 * 1000 + seconds * 1000 + milliseconds;
  }

  String _getSubTitle(PlayerProperties properties) {
    String subTitle = properties.artists;
    if (properties.albumName != null && properties.albumName.isNotEmpty) {
      subTitle = subTitle + '－' + properties.albumName;
    }
    return subTitle;
  }

  @override
  Widget build(BuildContext context) {
    _playerProperties =
        Provider.of<PlayerPropertiesNotifier>(context).playerProperties;
    List<LyricEntry> lyrics = _buildLyricData();
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: _albumPic,
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                elevation: 0,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                actions: _buildTrailing(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _playerProperties.songName,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(_getSubTitle(_playerProperties),
                        style: TextStyle(color: Colors.white, fontSize: 12))
                  ],
                ),
                backgroundColor: Colors.black26),
            body: Stack(
              children: <Widget>[
                BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      color: Colors.black26,
                    )),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Image.asset('icons/recoder_bg.png',
                                  width: 220),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              width: 190,
                              height: 190,
                              child: AlbumRotation(
                                  albumPic: _playerProperties.albumPicUrl),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        child: LyricView(
                      lyrics: lyrics,
                      unSelectedTextStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontSize: 14,
                          wordSpacing: 2),
                      selectedTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          wordSpacing: 2),
                    )),
                    PlayerSlider(),
                    PlayViewBottomButtons(playerProperties: _playerProperties)
                  ],
                )
              ],
            )));
  }

  void _funcSelect(_FuncValue value) {
    if (_playerProperties.sid == null) {
      return;
    }
    if (value == _FuncValue.F1) {
      DownloadListModel downloadModel = DownloadListModel(
          sid: _playerProperties.sid,
          mid: _playerProperties.mid,
          sname: _playerProperties.songName,
          artists: _playerProperties.artists,
          albumId: _playerProperties.albumId,
          albumPic: _playerProperties.albumPicUrl,
          albumName: _playerProperties.albumName,
          source: _playerProperties.source);
      download(downloadModel);
    }
  }

  // 保存收藏歌曲到数据库
  _saveFavorite() async {
    FavoriteModel favoriteModel = FavoriteModel(
        sid: _playerProperties.sid,
        mid: _playerProperties.mid,
        sname: _playerProperties.songName,
        artists: _playerProperties.artists,
        albumId: _playerProperties.albumId,
        albumName: _playerProperties.albumName,
        source: _playerProperties.source);
    Provider.of<FavoriteListNotifier>(context, listen: false)
        .add(favoriteModel);
  }

  // 从收藏中移除
  _removeFavorite() {
    Provider.of<FavoriteListNotifier>(context, listen: false)
        .remove(sid: _playerProperties.sid, source: _playerProperties.source);
  }

  _buildTrailing() {
    bool exist = Provider.of<FavoriteListNotifier>(context).checkExist(
        sid: _playerProperties.sid, source: _playerProperties.source);
    bool isLocal = _playerProperties.isLocal;
    if (isLocal) {
      return [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Align(
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white)),
              child: Text(
                "本地",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        )
      ];
    } else {
      return [
        GestureDetector(
          child: exist
              ? SvgPicture.asset("icons/heart.svg", width: 30)
              : SvgPicture.asset("icons/heart_outline.svg", width: 30),
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
        PopupMenuButton(
          tooltip: '功能列表',
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  height: 20, value: _FuncValue.F1, child: Text('下载')),
            ];
          },
          onSelected: _funcSelect,
        )
      ];
    }
  }
}
