import 'package:flutter/foundation.dart';

// 播放器属性
class PlayerPropertiesNotifier with ChangeNotifier {
  // 播放器属性
  PlayerProperties _playerProperties = new PlayerProperties();

  PlayerProperties get playerProperties => this._playerProperties;

  updatePlayerProperties(PlayerProperties playerProperties) {
    this._playerProperties = playerProperties;
    notifyListeners();
  }
}

// 播放器需要的属性对象
class PlayerProperties {
  //歌曲主键
  int sid;

  // 歌曲唯一标志
  String mid;

  // 歌曲来源
  String source;

  // 播放地址
  String url;

  // 专辑图片地址
  String albumPicUrl;

  // 歌曲名称
  String songName;

  // 歌手
  String artists;

  // 专辑主键
  String albumId;

  // 专辑名称
  String albumName;

  // 歌词
  String lyric;

  // 是否本地文件，true-本地文件， false-网络文件
  bool isLocal;

  PlayerProperties(
      {this.sid,
      this.mid,
      this.url,
      this.source,
      this.albumId,
      this.albumPicUrl,
      this.artists = "未知歌手",
      this.songName = '未知歌名',
      this.albumName = '未知专辑',
      this.lyric,
      this.isLocal = false});
}
