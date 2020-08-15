/// version : "1.0.0"
/// updateMsgs : ["1.更新信息1","2.更新信息2"]

class UpgradeModel {
  String version;
  List<String> updateMsgs;

  UpgradeModel({this.version, this.updateMsgs});

  UpgradeModel.fromJson(Map<String, dynamic> json) {
    version = json["version"];
    updateMsgs =
        json["updateMsgs"] != null ? json["updateMsgs"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["version"] = version;
    map["updateMsgs"] = updateMsgs;
    return map;
  }
}
