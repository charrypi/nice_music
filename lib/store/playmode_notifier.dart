import 'package:flutter/foundation.dart';
import 'package:nicemusic/constants/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayModeNotifier with ChangeNotifier {
  // 播放模式，默认列表循环
  PlayMode _playMode = PlayMode.LIST_LOOP;

  PlayMode get playMode => this._playMode;

  PlayModeNotifier() {
    _initPlayNode();
  }

  // 改变播放模式
  changePlayMode(PlayMode playMode) async {
    this._playMode = playMode;
    SharedPreferences refs = await SharedPreferences.getInstance();
    refs.setString(Settings.playmode, playMode.toString());
    notifyListeners();
  }

  _initPlayNode() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String mode = refs.getString(Settings.playmode);
    if (mode != null) {
      this._playMode = PlayMode.values.firstWhere((m) => m.toString() == mode);
      notifyListeners();
    }
  }
}

enum PlayMode { SINGLE_LOOP, LIST_LOOP, RANDOM_LOOP }
