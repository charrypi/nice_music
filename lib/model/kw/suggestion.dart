/// 检索推荐
class Suggestion {
  int code;
  int curTime;
  List<String> data;
  String msg;
  String profileId;
  String reqId;

  Suggestion(
      {this.code,
      this.curTime,
      this.data,
      this.msg,
      this.profileId,
      this.reqId});

  Suggestion.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    curTime = json['curTime'];
    data = json['data'].cast<String>();
    msg = json['msg'];
    profileId = json['profileId'];
    reqId = json['reqId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['curTime'] = this.curTime;
    data['data'] = this.data;
    data['msg'] = this.msg;
    data['profileId'] = this.profileId;
    data['reqId'] = this.reqId;
    return data;
  }
}
