import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:nicemusic/common/upgrade/upgrade_tips_dialog.dart';
import 'package:nicemusic/common/upgrade/upgrade_model.dart';
import 'package:nicemusic/util/request.dart';
import 'package:package_info/package_info.dart';

const updateUrl =
    "https://cdn.jsdelivr.net/gh/charrypi/nice_music@master/upgrade.json";

checkUpdate(MethodChannel paltform) async {
  try {
    Response response = await HttpRequest.getInstance().get(updateUrl);
    if (response.statusCode == HttpStatus.ok) {
      UpgradeModel upgradeModel = UpgradeModel.fromJson(response.data);
      String remoteVersion = upgradeModel.version;
      // 获取app版本
//      String packageVersion = await GetVersion.projectVersion;
      if (true) {
        BotToast.showAnimationWidget(
            clickClose: false,
            allowClick: false,
            crossPage: true,
            onlyOne: true,
            animationDuration: Duration(milliseconds: 500),
            toastBuilder: (cancelFunc) {
              return UpgradeModal(upgradeModel.updateMsgs,
                  upgradeModel.downloadUrl, cancelFunc);
            });
      }
    }
  } catch (e,s) {
    print(e);
    print(s);
  }
}

// 比较版本号
bool _compareVersion(String remoteVersion, String packageVersion) {
  List<String> remoteVersions = remoteVersion.split(".");
  List<String> packageVersions = packageVersion.split(".");
  for (int i = 0; i < remoteVersion.length; i++) {
    if (int.parse(remoteVersions[i]) > int.parse(packageVersions[i])) {
      return true;
    }
  }
  return false;
}
