import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

// 播放器状态
class PlayerStateNotifier with ChangeNotifier {
  // 播放器状态
  AudioPlayerState audioPlayerState;

  // 总时长
  Duration duration;

  // 当前位置时间
  Duration position;

  // 设置播放时长
  void setDuration(Duration duration) {
    this.duration = duration;
    notifyListeners();
  }

  // 设置当前播放进度
  void setPosition(Duration position) {
    this.position = position;
    notifyListeners();
  }

  // 改变播放器状态
  changePlayerState(AudioPlayerState audioPlayerState) {
    this.audioPlayerState = audioPlayerState;
    notifyListeners();
  }
}
