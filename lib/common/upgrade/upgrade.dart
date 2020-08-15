import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:nicemusic/common/upgrade/upgrade_model.dart';
import 'package:nicemusic/util/request.dart';
import 'package:package_info/package_info.dart';

const updateUrl =
    "https://gitee.com/bigbang92/nice_music/raw/master/upgrade.json";

checkUpdate(MethodChannel paltform) async {
  Response response = await HttpRequest.getInstance().get(updateUrl);
  if (response.statusCode == HttpStatus.ok) {
    Map<String, dynamic> data = json.decode(response.data);
    UpgradeModel upgradeModel = UpgradeModel.fromJson(data);
    print(upgradeModel.version);
    // 获取app版本
    String packageVersion = await GetVersion.platformVersion;
    print('packageVersion:$packageVersion');

    BotToast.showText(text: packageVersion);
  }
}

packageInfoMock() {
  const MethodChannel('plugins.flutter.io/package_info')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'ABC',
        'packageName': 'A.B.C',
        'version': '1.0.0',
      };
    }
    return null;
  });
}
