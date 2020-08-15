import 'package:nicemusic/api/kw/kw_request_api.dart';
import 'package:nicemusic/api/tx/tx_request_api.dart';
import 'package:nicemusic/api/wy/wy_request_api.dart';
import 'package:nicemusic/model/music_platform.dart';

/// 音乐平台常量列表
class MusicPlatforms {
  // 网易
  static final MusicPlatform wy =
      MusicPlatform("icons/wy_logo.jpg", "网易", "wy", WyRequestApi());

  // 酷我
  static final MusicPlatform kw =
      MusicPlatform("icons/kw_logo.png", "酷我", "kw", KwRequestApi());

  // tx
  static final MusicPlatform qq =
      MusicPlatform("icons/qq_logo.png", "QQ", "qq", TxRequestApi());

  // 平台map，根据code查找平台对象（dart中的mirrors不支持flutter，原打算反射获取静态变量列表获取平台对象）
  static Map<String, MusicPlatform> platforms = {
    wy.code: wy,
    kw.code: kw,
    qq.code: qq
  };

  // 获取平台对象
  static MusicPlatform get(String code) {
    return platforms[code];
  }
}
