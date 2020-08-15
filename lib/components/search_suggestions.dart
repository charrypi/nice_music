import 'package:flutter/material.dart';
import 'package:nicemusic/util/random_color.dart';
import 'package:nicemusic/constants/search_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/search_history.dart';

/// 搜索推荐内容面板
class SearchSuggestions extends StatefulWidget {
  //选择回调
  final selectCallBack;

  SearchSuggestions({Key key, this.selectCallBack}) : super(key: key);

  @override
  _SearchSuggestionsState createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  List<OutlineButton> searchBtns = List<OutlineButton>();

  @override
  void initState() {
    super.initState();
    _getSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('最近搜索历史',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              Spacer(),
              GestureDetector(
                  child: Icon(Icons.delete_outline, color: Colors.grey),
                  onTap: () {
                    _clearHistory();
                  })
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: -5,
              children: this.searchBtns,
            ),
          )
        ],
      ),
    );
  }

  void _getSearchHistory() async {
    List<String> queryList = await _getSavedSearchData();
    setState(() {
      _buildHistoryBtn(queryList == null ? [] : queryList.reversed.toList());
    });
  }

  Future<List<String>> _getSavedSearchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(SearchHistory.historyKey);
  }

  void _buildHistoryBtn(List<String> queryList) {
    queryList.forEach((queryStr) {
      searchBtns.add(OutlineButton(
          borderSide: BorderSide(color: RandomColor.randomColor()),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Text(queryStr),
          onPressed: () {
            widget.selectCallBack(queryStr);
          }));
    });
  }

  void _clearHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      searchBtns.clear();
      sharedPreferences.setString(SearchHistory.historyKey, null);
    });
  }
}
