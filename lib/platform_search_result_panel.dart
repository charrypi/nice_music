import 'package:flutter/material.dart';
import 'package:nicemusic/components/kw/kw_song_list.dart';
import 'package:nicemusic/components/song_list_contaner.dart';
import 'package:nicemusic/components/tx/tx_song_list.dart';
import 'package:nicemusic/components/vtabs.dart';
import 'package:nicemusic/store/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/search_event.dart';
import 'package:nicemusic/components/wy/wy_songs_list.dart';

class PlatformSearchResultList extends StatefulWidget {
  @override
  _PlatformSearchResultListState createState() =>
      _PlatformSearchResultListState();
}

class _PlatformSearchResultListState extends State<PlatformSearchResultList> {
  // 选择的tab 索引
  int selectIndex = 0;

  // 搜索关键字
  String keyWord;

  /// 声明平台tab和对应面板关系,实际关系是<MusicPlatform, Widget>，
  /// value要求是Widget，但后续需要对面板进行操作，dart无法自动转型（该Widget实现了SongListContainer接口），故这里不做显式声明
  Map _platforms = {
    MusicPlatforms.wy: WySongList(api: MusicPlatforms.wy.api),
    MusicPlatforms.kw: KwSongList(api: MusicPlatforms.kw.api),
    MusicPlatforms.qq: TxSongList(api: MusicPlatforms.qq.api)
  };

  @override
  void initState() {
    super.initState();
    eventBus.on<SearchEvent>().listen((event) {
      this.keyWord = event.keyWord;
      if (this.keyWord != null || this.keyWord.isNotEmpty) {
        _searchList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VTabs(
        indicatorColor: Color(Provider.of<ThemeNotifier>(context).primaryColor),
        selectedTabBackgroundColor:
            Color(Provider.of<ThemeNotifier>(context).primaryColor)
                .withOpacity(0.1),
        initialIndex: selectIndex,
        onSelect: (index) {
          this.selectIndex = index;
          _searchList();
        },
        tabsWidth: 80,
        tabs: _platforms.keys.map((e) => _buildTab(e.icon, e.name)).toList(),
        contents: _platforms.values.map<Widget>((e) => e).toList());
  }

  // 构造tab控件
  Tab _buildTab(String assetsImag, String label) {
    return Tab(
        child: Container(
            margin: EdgeInsets.only(bottom: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(image: AssetImage(assetsImag), width: 20),
                Text(label)
              ],
            )));
  }

  // 开启根据输入内容初始化检索页面
  void _searchList() {
    SongListContainer container = _platforms.values.elementAt(this.selectIndex);
    container.onQuery(keyWord);
  }
}
