import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nicemusic/util/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UpgradeProgressDialog extends StatefulWidget {
  final String downloadUrl;
  final Function cancel;

  UpgradeProgressDialog(this.downloadUrl, this.cancel);

  @override
  _UpgradeProgressDialogState createState() => _UpgradeProgressDialogState();
}

class _UpgradeProgressDialogState extends State<UpgradeProgressDialog> {
  // 下载百分比
  int percent = 0;
  CancelToken _cancelToken = CancelToken();
  String savePath = "";

  @override
  void initState() {
    super.initState();
    download();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("正在更新中，请稍候"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: LinearPercentIndicator(
        percent: percent / 100,
        progressColor: Colors.blueAccent,
        lineHeight: 10,
        trailing: Text("$percent%"),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _cancelToken.cancel('user cancel');
              widget.cancel();
            },
            child: Text(
              '取消',
              style: TextStyle(color: Colors.redAccent),
            )),
      ],
    );
  }

  download() async {
    try {
      Directory directory = await getTemporaryDirectory();
      savePath = directory.path + "/app.apk";

      HttpRequest.getInstance().download(widget.downloadUrl, savePath,
          (count, total) {
        setState(() {
          percent = int.parse((count / total * 100).toStringAsFixed(0));
        });
        if (count == total) {
          // 安装
          widget.cancel();
          _instalApk();
        }
      });
    } catch (e, s) {
      print(e);
      print(s);
      widget.cancel();
      BotToast.showText(text: "更新异常");
    }
  }

  void _instalApk() async {
    try {
      const platform = const MethodChannel("nicemusic");
      await platform.invokeMethod("install", {"path": savePath});
    } catch (e) {
      print(e);
    }
  }
}
