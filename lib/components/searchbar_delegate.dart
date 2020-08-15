import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/constants/search_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nicemusic/components/search_suggestions.dart';
import 'package:nicemusic/api/kw/kw_request_api.dart';

// 搜索框代理
class SearchBarDelegate extends SearchDelegate<String> {
  SearchBarDelegate({String hintText}) : super(searchFieldLabel: hintText);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
            showSuggestions(context);
          })
    ];
  }

  // 搜索框前置控件
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, "");
        });
  }

  // 点击查询触发
  @override
  Widget buildResults(BuildContext context) {
    if (query != null && query.isNotEmpty) {
      // 先保存到本地存储
      _saveSearchHistory(query);
      // 根据搜索内容构建返回列表
      return FutureBuilder(future: getResult(), builder: _buildSuggestions);
    } else {
      return buildSuggestions(context);
    }
  }

  // 搜索提示内容
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO 智能提示内容,目前只显示搜索历史
    return SearchSuggestions(selectCallBack: (str) {
      query = str;
      showResults(context);
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }

  // 保存搜索历史到本地
  void _saveSearchHistory(String query) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> histories = sharedPreferences.get(SearchHistory.historyKey);
//    sharedPreferences.setStringList(SearchHistory.historyKey, null);
    if (histories == null) {
      sharedPreferences.setStringList(SearchHistory.historyKey, List<String>());
    }

    List<String> savedHistories =
        sharedPreferences.get(SearchHistory.historyKey);
    if (savedHistories.length >= 10) {
      savedHistories.removeAt(0);
    }
    // 剔除已经搜索过的字符串
    savedHistories.removeWhere((e) => e == query);
    savedHistories.add(query);
    sharedPreferences.setStringList(SearchHistory.historyKey, savedHistories);
  }

  Widget _buildSuggestions(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        break;
      case ConnectionState.none:
        break;
      case ConnectionState.waiting:
        return Container(
            alignment: Alignment.center,
            child: LoadingBouncingLine.square(borderColor: Colors.blue));
      case ConnectionState.done:
        List<String> suggestions = snapshot.data;
        if (suggestions == null || suggestions.length == 0) {
          return Align(
            child: Text('没有查询到任何结果~'),
          );
        }
        return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: _buildListTile(suggestions, index),
                      ),
                      onTap: () {
                        // 传递歌名到主页查询
                        close(context, suggestions[index]);
                      });
                },
                itemCount: suggestions.length));
    }
    return Text('未搜到任何结果');
  }

  // 异步获取查询结果，默认是查询网易单曲类型前10条结果
  Future getResult() async {
    KwRequestApi api = MusicPlatforms.kw.api;
    return await api.getSuggestions(query);
  }

  // 创建列表行
  Column _buildListTile(List<String> suggestions, int index) {
    List<Widget> rows = List<Widget>();
    String name = suggestions[index];
    rows.add(Row(children: <Widget>[
      Icon(Icons.search),
      Expanded(child: Text(name, overflow: TextOverflow.ellipsis))
    ]));
    return Column(children: rows);
  }
}
