import 'package:flutter/foundation.dart';

/// 播放器状态事件
class PlayerStateEvent {
  PlayerStateEnum state;

  PlayerStateEvent({@required this.state});
}

/// 播放器播放状态
/// CONNECTING 连接中
/// PREPARE 准备播放
/// ERROR 异常
enum PlayerStateEnum { CONNECTING, PREPARE, DONE, ERROR }
