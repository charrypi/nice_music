import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nicemusic/favorite.dart';
import 'package:nicemusic/play_list.dart';

import '../download_list.dart';

// 主页功能按钮内容组件
class MainFunctionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildFunctionButton("icons/play_list.png", "试听列表", () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return PlayList();
            }));
          }),
//          buildFunctionButton("icons/songs_list.png", "榜单", () {}),
          buildFunctionButton("icons/favorite.png", "收藏", () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FavoriteList();
            }));
          }),
          buildFunctionButton("icons/download.png", "下载", () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DownLoadList();
            }));
          })
        ],
      ),
    );
  }

  Container buildFunctionButton(
      String icon, String label, GestureTapCallback callback) {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Image(image: AssetImage(icon), width: 60),
            onTap: callback,
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              label,
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
