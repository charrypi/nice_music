import 'package:nicemusic/api/platform_api.dart';

/// 音乐平台对象
class MusicPlatform {
  // logo
  String icon;

  // 名称
  String name;

  // 编码
  String code;

  // 平台api接口对象
  PlatformApi api;

  MusicPlatform(this.icon, this.name, this.code, this.api);
}
