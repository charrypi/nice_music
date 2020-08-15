import 'package:flutter/foundation.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';
import 'package:nicemusic/store/playmode_notifier.dart';

// 播放器事件
class PlayerEvent {
  //命令
  PlayerCmd cmd;

  // 播放器属性
  PlayerProperties playerProperties;

  // 跳转到的时间
  Duration duration;

  // 播放列表id
  int pid;

  PlayerEvent(
      {@required this.cmd, this.playerProperties, this.duration, this.pid});
}

// 事件命令枚举列表
// 播放，恢复，暂停，下一首，上一首，停止，跳转
enum PlayerCmd { PLAY, RESUME, PAUSE, NEXT, FORWARD, STOP, SEEK }
