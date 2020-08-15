import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nicemusic/constants/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 主题provider
class ThemeNotifier with ChangeNotifier {

  // 主色调
  int _primaryColor = Colors.redAccent.value;

  int get primaryColor => this._primaryColor;

  ThemeNotifier() {
    _initLocalTheme();
  }

  updatePrimaryColor(int color) async {
    this._primaryColor = color;
    SharedPreferences localStore = await SharedPreferences.getInstance();
    localStore.setInt(Settings.theme, color);
    notifyListeners();
  }

  _initLocalTheme() async{
   SharedPreferences refs = await SharedPreferences.getInstance();
   int themeColor = refs.getInt(Settings.theme);
   if (themeColor != null) {
     this._primaryColor = themeColor;
     notifyListeners();
   }
  }
}
