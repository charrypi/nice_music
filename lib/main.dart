import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nicemusic/common/upgrade/upgrade.dart';
import 'package:nicemusic/home.dart';
import 'package:nicemusic/store/favorite_list_notifier.dart';
import 'package:nicemusic/common/navkey.dart';
import 'package:provider/provider.dart';
import 'package:nicemusic/store/play_list_notifier.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';
import 'package:nicemusic/store/player_state_notifier.dart';
import 'package:nicemusic/store/playmode_notifier.dart';
import 'package:nicemusic/store/theme_notifier.dart';
import 'package:nicemusic/store/downloading_files_notifier.dart';
import 'package:nicemusic/util/db_util.dart';

void main() async {
  //    debugPaintBaselinesEnabled = true;
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  // 初始化数据库
  DbUtil.getInstance().getDb();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    const platform =  const MethodChannel('nicemusic');
    checkUpdate(platform);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PlayerStateNotifier()),
          ChangeNotifierProvider(create: (context) => PlayModeNotifier()),
          ChangeNotifierProvider(create: (context) => PlayListNotifier()),
          ChangeNotifierProvider(
              create: (context) => PlayerPropertiesNotifier()),
          ChangeNotifierProvider(
              create: (context) => DownLoadingFilesNotifier()),
          ChangeNotifierProvider(create: (context) => FavoriteListNotifier())
        ],
        child: MaterialApp(
          builder: BotToastInit(),
          navigatorKey: NavKey.navKey,
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor:
                  Color(Provider.of<ThemeNotifier>(context).primaryColor)),
          home: Home(),
        ));
  }
}
