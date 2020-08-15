import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nicemusic/store/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<Directory> _tempDirectory;

  @override
  void initState() {
    super.initState();
    _tempDirectory = getTemporaryDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 0,
          title: Text('设置', style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(children: <Widget>[
            Container(
                child: Row(
              children: <Widget>[Icon(Icons.palette), Text("主题颜色")],
            )),
            Container(
              margin: EdgeInsets.only(top: 15,bottom: 15),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Wrap(
                      spacing: 20,
                      children: _buildColorsRectangle(),
                    ),
                  )
                ],
              ),
            ),
            Container(
                child: Row(
              children: <Widget>[
                Icon(Icons.file_download),
                Text("下载文件目录"),
              ],
            )),
            Container(
              margin: EdgeInsets.only(top: 15,bottom: 15),
              child: Row(
                children: <Widget>[
                  FutureBuilder(
                      future: _tempDirectory, builder: _buildDirectory)
                ],
              ),
            )
          ]),
        ));
  }

  // 构建颜色色块
  _buildColorsRectangle() {
    List<Color> colors = [
      Colors.redAccent,
      Colors.lightBlueAccent,
      Colors.yellowAccent,
      Colors.green
    ];
    List<InkWell> rectangles = List();
    colors.forEach((color) {
      bool checked =
          Provider.of<ThemeNotifier>(context).primaryColor == color.value;
      rectangles.add(InkWell(
        onTap: () {
          Provider.of<ThemeNotifier>(context, listen: false)
              .updatePrimaryColor(color.value);
        },
        child: Stack(
          children: <Widget>[
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(color: color),
            ),
            checked
                ? Container(
                    width: 35,
                    height: 35,
                    child: Icon(Icons.check, color: Colors.white))
                : Container(),
          ],
        ),
      ));
    });
    return rectangles;
  }

  Widget _buildDirectory(BuildContext context, AsyncSnapshot snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('获取缓存目录异常');
      } else if (snapshot.hasData) {
        text = Text('${snapshot.data.path}', style: TextStyle(fontSize: 16),);
      } else {
        text = const Text('路径不可用！');
      }
    }
    return text;
  }
}
