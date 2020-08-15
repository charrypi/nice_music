/// code : 0
/// ts : 1596448763606
/// start_ts : 1596448763603
/// req_0 : {"code":0,"data":{"expiration":80400,"login_key":"","midurlinfo":[{"common_downfromtag":0,"errtype":"","filename":"C400000HjG8v1DTWRO.m4a","flowfromtag":"","flowurl":"","hisbuy":0,"hisdown":0,"isbuy":0,"isonly":0,"onecan":0,"opi128kurl":"","opi192koggurl":"","opi192kurl":"","opi30surl":"","opi48kurl":"","opi96kurl":"","opiflackurl":"","p2pfromtag":0,"pdl":0,"pneed":0,"pneedbuy":0,"premain":0,"purl":"C400000HjG8v1DTWRO.m4a?guid=358840384&vkey=3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5&uin=0&fromtag=66","qmdlfromtag":0,"result":0,"songmid":"001X0PDf0W4lBq","tips":"","uiAlert":0,"vip_downfromtag":0,"vkey":"3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5","wififromtag":"","wifiurl":""}],"msg":"119.130.206.41","retcode":0,"servercheck":"0502f67d8cf451662c4b46417d571295","sip":["http://ws.stream.qqmusic.qq.com/","http://isure.stream.qqmusic.qq.com/"],"testfile2g":"C400003mAan70zUy5O.m4a?guid=358840384&vkey=9C2C9153179EC7CE769DC7E206955C46B2D67A8FE91CC1BFE1AD1F4FD2081D3E5FE2B5ADB6FB6C69856BA9555017E01211CCD06F7857182C&uin=&fromtag=3","testfilewifi":"C400003mAan70zUy5O.m4a?guid=358840384&vkey=9C2C9153179EC7CE769DC7E206955C46B2D67A8FE91CC1BFE1AD1F4FD2081D3E5FE2B5ADB6FB6C69856BA9555017E01211CCD06F7857182C&uin=&fromtag=3","thirdip":["",""],"uin":"","verify_type":0}}

class TxPlayUrl {
  int code;
  int ts;
  int startTs;
  Req_0 req0;

  TxPlayUrl({this.code, this.ts, this.startTs, this.req0});

  TxPlayUrl.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    ts = json["ts"];
    startTs = json["startTs"];
    req0 = json["req_0"] != null ? Req_0.fromJson(json["req_0"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    map["ts"] = ts;
    map["startTs"] = startTs;
    if (req0 != null) {
      map["req0"] = req0.toJson();
    }
    return map;
  }
}

/// code : 0
/// data : {"expiration":80400,"login_key":"","midurlinfo":[{"common_downfromtag":0,"errtype":"","filename":"C400000HjG8v1DTWRO.m4a","flowfromtag":"","flowurl":"","hisbuy":0,"hisdown":0,"isbuy":0,"isonly":0,"onecan":0,"opi128kurl":"","opi192koggurl":"","opi192kurl":"","opi30surl":"","opi48kurl":"","opi96kurl":"","opiflackurl":"","p2pfromtag":0,"pdl":0,"pneed":0,"pneedbuy":0,"premain":0,"purl":"C400000HjG8v1DTWRO.m4a?guid=358840384&vkey=3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5&uin=0&fromtag=66","qmdlfromtag":0,"result":0,"songmid":"001X0PDf0W4lBq","tips":"","uiAlert":0,"vip_downfromtag":0,"vkey":"3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5","wififromtag":"","wifiurl":""}],"msg":"119.130.206.41","retcode":0,"servercheck":"0502f67d8cf451662c4b46417d571295","sip":["http://ws.stream.qqmusic.qq.com/","http://isure.stream.qqmusic.qq.com/"],"testfile2g":"C400003mAan70zUy5O.m4a?guid=358840384&vkey=9C2C9153179EC7CE769DC7E206955C46B2D67A8FE91CC1BFE1AD1F4FD2081D3E5FE2B5ADB6FB6C69856BA9555017E01211CCD06F7857182C&uin=&fromtag=3","testfilewifi":"C400003mAan70zUy5O.m4a?guid=358840384&vkey=9C2C9153179EC7CE769DC7E206955C46B2D67A8FE91CC1BFE1AD1F4FD2081D3E5FE2B5ADB6FB6C69856BA9555017E01211CCD06F7857182C&uin=&fromtag=3","thirdip":["",""],"uin":"","verify_type":0}

class Req_0 {
  int code;
  Data data;

  Req_0({this.code, this.data});

  Req_0.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }
}

/// expiration : 80400
/// login_key : ""
/// midurlinfo : [{"common_downfromtag":0,"errtype":"","filename":"C400000HjG8v1DTWRO.m4a","flowfromtag":"","flowurl":"","hisbuy":0,"hisdown":0,"isbuy":0,"isonly":0,"onecan":0,"opi128kurl":"","opi192koggurl":"","opi192kurl":"","opi30surl":"","opi48kurl":"","opi96kurl":"","opiflackurl":"","p2pfromtag":0,"pdl":0,"pneed":0,"pneedbuy":0,"premain":0,"purl":"C400000HjG8v1DTWRO.m4a?guid=358840384&vkey=3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5&uin=0&fromtag=66","qmdlfromtag":0,"result":0,"songmid":"001X0PDf0W4lBq","tips":"","uiAlert":0,"vip_downfromtag":0,"vkey":"3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5","wififromtag":"","wifiurl":""}]
/// msg : "119.130.206.41"
/// retcode : 0
/// servercheck : "0502f67d8cf451662c4b46417d571295"
/// sip : ["http://ws.stream.qqmusic.qq.com/","http://isure.stream.qqmusic.qq.com/"]
/// testfile2g : "C400003mAan70zUy5O.m4a?guid=358840384&vkey=9C2C9153179EC7CE769DC7E206955C46B2D67A8FE91CC1BFE1AD1F4FD2081D3E5FE2B5ADB6FB6C69856BA9555017E01211CCD06F7857182C&uin=&fromtag=3"
/// testfilewifi : "C400003mAan70zUy5O.m4a?guid=358840384&vkey=9C2C9153179EC7CE769DC7E206955C46B2D67A8FE91CC1BFE1AD1F4FD2081D3E5FE2B5ADB6FB6C69856BA9555017E01211CCD06F7857182C&uin=&fromtag=3"
/// thirdip : ["",""]
/// uin : ""
/// verify_type : 0

class Data {
  int expiration;
  String loginKey;
  List<Midurlinfo> midurlinfo;
  String msg;
  int retcode;
  String servercheck;
  List<String> sip;
  String testfile2g;
  String testfilewifi;
  List<String> thirdip;
  String uin;
  int verifyType;

  Data(
      {this.expiration,
      this.loginKey,
      this.midurlinfo,
      this.msg,
      this.retcode,
      this.servercheck,
      this.sip,
      this.testfile2g,
      this.testfilewifi,
      this.thirdip,
      this.uin,
      this.verifyType});

  Data.fromJson(Map<String, dynamic> json) {
    expiration = json["expiration"];
    loginKey = json["loginKey"];
    if (json["midurlinfo"] != null) {
      midurlinfo = [];
      json["midurlinfo"].forEach((v) {
        midurlinfo.add(Midurlinfo.fromJson(v));
      });
    }
    msg = json["msg"];
    retcode = json["retcode"];
    servercheck = json["servercheck"];
    sip = json["sip"] != null ? json["sip"].cast<String>() : [];
    testfile2g = json["testfile2g"];
    testfilewifi = json["testfilewifi"];
    thirdip = json["thirdip"] != null ? json["thirdip"].cast<String>() : [];
    uin = json["uin"];
    verifyType = json["verifyType"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["expiration"] = expiration;
    map["loginKey"] = loginKey;
    if (midurlinfo != null) {
      map["midurlinfo"] = midurlinfo.map((v) => v.toJson()).toList();
    }
    map["msg"] = msg;
    map["retcode"] = retcode;
    map["servercheck"] = servercheck;
    map["sip"] = sip;
    map["testfile2g"] = testfile2g;
    map["testfilewifi"] = testfilewifi;
    map["thirdip"] = thirdip;
    map["uin"] = uin;
    map["verifyType"] = verifyType;
    return map;
  }
}

/// common_downfromtag : 0
/// errtype : ""
/// filename : "C400000HjG8v1DTWRO.m4a"
/// flowfromtag : ""
/// flowurl : ""
/// hisbuy : 0
/// hisdown : 0
/// isbuy : 0
/// isonly : 0
/// onecan : 0
/// opi128kurl : ""
/// opi192koggurl : ""
/// opi192kurl : ""
/// opi30surl : ""
/// opi48kurl : ""
/// opi96kurl : ""
/// opiflackurl : ""
/// p2pfromtag : 0
/// pdl : 0
/// pneed : 0
/// pneedbuy : 0
/// premain : 0
/// purl : "C400000HjG8v1DTWRO.m4a?guid=358840384&vkey=3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5&uin=0&fromtag=66"
/// qmdlfromtag : 0
/// result : 0
/// songmid : "001X0PDf0W4lBq"
/// tips : ""
/// uiAlert : 0
/// vip_downfromtag : 0
/// vkey : "3FA453D1FD82476DC5DBD2214437CFC33A7A81BD68D4B09974ED466369C0495934DD9FFCBF074739C20AB9A2B6D105B1BFBACD3233102CE5"
/// wififromtag : ""
/// wifiurl : ""

class Midurlinfo {
  int commonDownfromtag;
  String errtype;
  String filename;
  String flowfromtag;
  String flowurl;
  int hisbuy;
  int hisdown;
  int isbuy;
  int isonly;
  int onecan;
  String opi128kurl;
  String opi192koggurl;
  String opi192kurl;
  String opi30surl;
  String opi48kurl;
  String opi96kurl;
  String opiflackurl;
  int p2pfromtag;
  int pdl;
  int pneed;
  int pneedbuy;
  int premain;
  String purl;
  int qmdlfromtag;
  int result;
  String songmid;
  String tips;
  int uiAlert;
  int vipDownfromtag;
  String vkey;
  String wififromtag;
  String wifiurl;

  Midurlinfo(
      {this.commonDownfromtag,
      this.errtype,
      this.filename,
      this.flowfromtag,
      this.flowurl,
      this.hisbuy,
      this.hisdown,
      this.isbuy,
      this.isonly,
      this.onecan,
      this.opi128kurl,
      this.opi192koggurl,
      this.opi192kurl,
      this.opi30surl,
      this.opi48kurl,
      this.opi96kurl,
      this.opiflackurl,
      this.p2pfromtag,
      this.pdl,
      this.pneed,
      this.pneedbuy,
      this.premain,
      this.purl,
      this.qmdlfromtag,
      this.result,
      this.songmid,
      this.tips,
      this.uiAlert,
      this.vipDownfromtag,
      this.vkey,
      this.wififromtag,
      this.wifiurl});

  Midurlinfo.fromJson(Map<String, dynamic> json) {
    commonDownfromtag = json["commonDownfromtag"];
    errtype = json["errtype"];
    filename = json["filename"];
    flowfromtag = json["flowfromtag"];
    flowurl = json["flowurl"];
    hisbuy = json["hisbuy"];
    hisdown = json["hisdown"];
    isbuy = json["isbuy"];
    isonly = json["isonly"];
    onecan = json["onecan"];
    opi128kurl = json["opi128kurl"];
    opi192koggurl = json["opi192koggurl"];
    opi192kurl = json["opi192kurl"];
    opi30surl = json["opi30surl"];
    opi48kurl = json["opi48kurl"];
    opi96kurl = json["opi96kurl"];
    opiflackurl = json["opiflackurl"];
    p2pfromtag = json["p2pfromtag"];
    pdl = json["pdl"];
    pneed = json["pneed"];
    pneedbuy = json["pneedbuy"];
    premain = json["premain"];
    purl = json["purl"];
    qmdlfromtag = json["qmdlfromtag"];
    result = json["result"];
    songmid = json["songmid"];
    tips = json["tips"];
    uiAlert = json["uiAlert"];
    vipDownfromtag = json["vipDownfromtag"];
    vkey = json["vkey"];
    wififromtag = json["wififromtag"];
    wifiurl = json["wifiurl"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["commonDownfromtag"] = commonDownfromtag;
    map["errtype"] = errtype;
    map["filename"] = filename;
    map["flowfromtag"] = flowfromtag;
    map["flowurl"] = flowurl;
    map["hisbuy"] = hisbuy;
    map["hisdown"] = hisdown;
    map["isbuy"] = isbuy;
    map["isonly"] = isonly;
    map["onecan"] = onecan;
    map["opi128kurl"] = opi128kurl;
    map["opi192koggurl"] = opi192koggurl;
    map["opi192kurl"] = opi192kurl;
    map["opi30surl"] = opi30surl;
    map["opi48kurl"] = opi48kurl;
    map["opi96kurl"] = opi96kurl;
    map["opiflackurl"] = opiflackurl;
    map["p2pfromtag"] = p2pfromtag;
    map["pdl"] = pdl;
    map["pneed"] = pneed;
    map["pneedbuy"] = pneedbuy;
    map["premain"] = premain;
    map["purl"] = purl;
    map["qmdlfromtag"] = qmdlfromtag;
    map["result"] = result;
    map["songmid"] = songmid;
    map["tips"] = tips;
    map["uiAlert"] = uiAlert;
    map["vipDownfromtag"] = vipDownfromtag;
    map["vkey"] = vkey;
    map["wififromtag"] = wififromtag;
    map["wifiurl"] = wifiurl;
    return map;
  }
}
