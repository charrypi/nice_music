import 'package:flutter/material.dart';
import 'package:nicemusic/event/search_event.dart';
import 'package:nicemusic/components/home_drawer.dart';
import 'package:nicemusic/components/home_function_bar.dart';
import 'package:nicemusic/platform_search_result_panel.dart';
import 'package:nicemusic/components/searchbar_delegate.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/components/audio_player.dart';

import 'components/searchbar_delegate.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          title: Text('花生音乐', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            Builder(builder: (context) {
              return IconButton(
                  icon: Icon(Icons.search),
                  tooltip: '搜搜吧',
                  onPressed: () async {
                    String returnSearchStr = await showSearch(
                        context: context,
                        delegate: SearchBarDelegate(hintText: "输入你想听的歌名或歌手名"));
                    if (returnSearchStr != null && returnSearchStr.isNotEmpty) {
                      eventBus.fire(SearchEvent(returnSearchStr));
                    }
                  });
            })
          ],
        ),
        drawer: Drawer(child: MainDrawer(), elevation: 0),
        bottomNavigationBar: Stack(
          children: <Widget>[
            BottomAppBar(
              child: MusicPlayer(),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            MainFunctionBar(),
            Divider(
              height: 3,
            ),
            Expanded(child: PlatformSearchResultList())
          ],
        ));
  }
}
