/// code : 200
/// curTime : 1596015435093
/// data : {"musicrid":"MUSIC_142655450","artist":"周杰伦","mvpayinfo":{"play":0,"vid":0,"down":0},"pic":"http://img3.kuwo.cn/star/albumcover/300/48/47/309391875.jpg","isstar":0,"rid":142655450,"upPcStr":"kuwo://play/?play=MQ==&num=MQ==&musicrid0=TVVTSUNfMTQyNjU1NDUw&name0=TW9qaXRv&artist0=1ty93MLX&album0=TW9qaXRv&artistid0=MzM2&albumid0=MTQzNjUwNjY=&playsource=d2ViwK3G8L/Nu6e2yy0+MjAxNrDmtaXH+tKz","duration":185,"score100":"88","content_type":"0","mvPlayCnt":1320641,"track":1,"hasLossless":true,"hasmv":1,"releaseDate":"2020-06-12","album":"Mojito","albumid":14365066,"pay":"255","artistid":336,"albumpic":"http://img3.kuwo.cn/star/albumcover/500/48/47/309391875.jpg","songTimeMinutes":"03:05","isListenFee":true,"mvUpPcStr":"kuwo://play/?play=MQ==&num=MQ==&musicrid0=TVVTSUNfMTQyNjU1NDUw&name0=TW9qaXRv&artist0=1ty93MLX&album0=TW9qaXRv&artistid0=MzM2&albumid0=MTQzNjUwNjY=&playsource=d2ViwK3G8L/Nu6e2yy0+MjAxNrDmtaXH+tKz&media=bXY=&mvid0=MA==&mvinfo_play0=MA==&mvinfo_download0=MA==","pic120":"http://img3.kuwo.cn/star/albumcover/120/48/47/309391875.jpg","albuminfo":"夏季限定特调上架！\n\n周杰伦Jay Chou\n最新拉丁嘻哈沁脾情歌\nMOJITO\n一起恋上古巴的微醺浪漫\n\n在古巴的海滩，点一杯大文豪海明威最爱的Mojito\n和周杰伦一起品尝异国恋情般的微醺特调\n阅读整个夏季的浪漫！\n\n2020已迈进下半年，终于听见周杰伦！\n睽违多时周杰伦再推新单曲，用音乐环游世界的他，这次带领大家来到充满音乐、舞蹈的迷幻之城「古巴」，以古巴最著名的鸡尾酒「Mojito」为名而写的这首情歌，一如古巴这个城市以它独有的建筑风景，写成一封封献给天空的情书，「Mojito」就是献给每一对来自世界各地的恋人，最浪漫的特调。\n\n「Mojito」是一种传统的古巴鸡尾酒，更是大文豪海明威的最爱，如缪斯女神般存在的Mojito，黄俊郎以此酒为主题，为周杰伦这首充满古巴风情、带着轻快的节奏、随兴摇摆曲风的创作，写出一种遇见爱情时，令人神往的浪漫情调；来到一个第一次到访的异国城市，心头涌上一种「旧城市里的新恋情」的激荡，是每个旅人的心情，彷佛前世就来过一般既视感与命运感，让旧城更添一种神秘向往。\n\n周杰伦以最信手捻来的迷人旋律、以浓郁摇曳的拉丁曲风搭配慵懒不羁的嘻哈，领着好友群，穿着异国情调清爽的夏衫，开着鲜艳复古的老爷车随性捕捉古巴景致；更在ＭＶ里跳着轻快骚莎（Salsa）的舞步，让人不自觉跟着摇摆，心也跟着一起私奔到连海明威都流连忘返的古巴！\n\n【未经许可，不得翻唱或使用】","name":"Mojito","online":1,"payInfo":{"play":"1111","download":"1111","cannotDownload":0,"cannotOnlinePlay":0,"feeType":{"album":"1"},"down":"1111"}}
/// msg : "success"
/// profileId : "site"
/// reqId : "185e8a7220bad44f959304e6263bcd1a"

class KwMusicInfo {
  int code;
  int curTime;
  Data data;
  String msg;
  String profileId;
  String reqId;

  KwMusicInfo(
      {this.code,
      this.curTime,
      this.data,
      this.msg,
      this.profileId,
      this.reqId});

  KwMusicInfo.fromJson(dynamic json) {
    code = json["code"];
    curTime = json["curTime"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    msg = json["msg"];
    profileId = json["profileId"];
    reqId = json["reqId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    map["curTime"] = curTime;
    if (data != null) {
      map["data"] = data.toJson();
    }
    map["msg"] = msg;
    map["profileId"] = profileId;
    map["reqId"] = reqId;
    return map;
  }
}

/// musicrid : "MUSIC_142655450"
/// artist : "周杰伦"
/// mvpayinfo : {"play":0,"vid":0,"down":0}
/// pic : "http://img3.kuwo.cn/star/albumcover/300/48/47/309391875.jpg"
/// isstar : 0
/// rid : 142655450
/// upPcStr : "kuwo://play/?play=MQ==&num=MQ==&musicrid0=TVVTSUNfMTQyNjU1NDUw&name0=TW9qaXRv&artist0=1ty93MLX&album0=TW9qaXRv&artistid0=MzM2&albumid0=MTQzNjUwNjY=&playsource=d2ViwK3G8L/Nu6e2yy0+MjAxNrDmtaXH+tKz"
/// duration : 185
/// score100 : "88"
/// content_type : "0"
/// mvPlayCnt : 1320641
/// track : 1
/// hasLossless : true
/// hasmv : 1
/// releaseDate : "2020-06-12"
/// album : "Mojito"
/// albumid : 14365066
/// pay : "255"
/// artistid : 336
/// albumpic : "http://img3.kuwo.cn/star/albumcover/500/48/47/309391875.jpg"
/// songTimeMinutes : "03:05"
/// isListenFee : true
/// mvUpPcStr : "kuwo://play/?play=MQ==&num=MQ==&musicrid0=TVVTSUNfMTQyNjU1NDUw&name0=TW9qaXRv&artist0=1ty93MLX&album0=TW9qaXRv&artistid0=MzM2&albumid0=MTQzNjUwNjY=&playsource=d2ViwK3G8L/Nu6e2yy0+MjAxNrDmtaXH+tKz&media=bXY=&mvid0=MA==&mvinfo_play0=MA==&mvinfo_download0=MA=="
/// pic120 : "http://img3.kuwo.cn/star/albumcover/120/48/47/309391875.jpg"
/// albuminfo : "夏季限定特调上架！\n\n周杰伦Jay Chou\n最新拉丁嘻哈沁脾情歌\nMOJITO\n一起恋上古巴的微醺浪漫\n\n在古巴的海滩，点一杯大文豪海明威最爱的Mojito\n和周杰伦一起品尝异国恋情般的微醺特调\n阅读整个夏季的浪漫！\n\n2020已迈进下半年，终于听见周杰伦！\n睽违多时周杰伦再推新单曲，用音乐环游世界的他，这次带领大家来到充满音乐、舞蹈的迷幻之城「古巴」，以古巴最著名的鸡尾酒「Mojito」为名而写的这首情歌，一如古巴这个城市以它独有的建筑风景，写成一封封献给天空的情书，「Mojito」就是献给每一对来自世界各地的恋人，最浪漫的特调。\n\n「Mojito」是一种传统的古巴鸡尾酒，更是大文豪海明威的最爱，如缪斯女神般存在的Mojito，黄俊郎以此酒为主题，为周杰伦这首充满古巴风情、带着轻快的节奏、随兴摇摆曲风的创作，写出一种遇见爱情时，令人神往的浪漫情调；来到一个第一次到访的异国城市，心头涌上一种「旧城市里的新恋情」的激荡，是每个旅人的心情，彷佛前世就来过一般既视感与命运感，让旧城更添一种神秘向往。\n\n周杰伦以最信手捻来的迷人旋律、以浓郁摇曳的拉丁曲风搭配慵懒不羁的嘻哈，领着好友群，穿着异国情调清爽的夏衫，开着鲜艳复古的老爷车随性捕捉古巴景致；更在ＭＶ里跳着轻快骚莎（Salsa）的舞步，让人不自觉跟着摇摆，心也跟着一起私奔到连海明威都流连忘返的古巴！\n\n【未经许可，不得翻唱或使用】"
/// name : "Mojito"
/// online : 1
/// payInfo : {"play":"1111","download":"1111","cannotDownload":0,"cannotOnlinePlay":0,"feeType":{"album":"1"},"down":"1111"}

class Data {
  String musicrid;
  String artist;
  Mvpayinfo mvpayinfo;
  String pic;
  int isstar;
  int rid;
  String upPcStr;
  int duration;
  String score100;
  String contentType;
  int mvPlayCnt;
  int track;
  bool hasLossless;
  int hasmv;
  String releaseDate;
  String album;
  int albumid;
  String pay;
  int artistid;
  String albumpic;
  String songTimeMinutes;
  bool isListenFee;
  String mvUpPcStr;
  String pic120;
  String albuminfo;
  String name;
  int online;
  PayInfo payInfo;

  Data(
      {this.musicrid,
      this.artist,
      this.mvpayinfo,
      this.pic,
      this.isstar,
      this.rid,
      this.upPcStr,
      this.duration,
      this.score100,
      this.contentType,
      this.mvPlayCnt,
      this.track,
      this.hasLossless,
      this.hasmv,
      this.releaseDate,
      this.album,
      this.albumid,
      this.pay,
      this.artistid,
      this.albumpic,
      this.songTimeMinutes,
      this.isListenFee,
      this.mvUpPcStr,
      this.pic120,
      this.albuminfo,
      this.name,
      this.online,
      this.payInfo});

  Data.fromJson(dynamic json) {
    musicrid = json["musicrid"];
    artist = json["artist"];
    mvpayinfo = json["mvpayinfo"] != null
        ? Mvpayinfo.fromJson(json["mvpayinfo"])
        : null;
    pic = json["pic"];
    isstar = json["isstar"];
    rid = json["rid"];
    upPcStr = json["upPcStr"];
    duration = json["duration"];
    score100 = json["score100"];
    contentType = json["contentType"];
    mvPlayCnt = json["mvPlayCnt"];
    track = json["track"];
    hasLossless = json["hasLossless"];
    hasmv = json["hasmv"];
    releaseDate = json["releaseDate"];
    album = json["album"];
    albumid = json["albumid"];
    pay = json["pay"];
    artistid = json["artistid"];
    albumpic = json["albumpic"];
    songTimeMinutes = json["songTimeMinutes"];
    isListenFee = json["isListenFee"];
    mvUpPcStr = json["mvUpPcStr"];
    pic120 = json["pic120"];
    albuminfo = json["albuminfo"];
    name = json["name"];
    online = json["online"];
    payInfo =
        json["payInfo"] != null ? PayInfo.fromJson(json["payInfo"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["musicrid"] = musicrid;
    map["artist"] = artist;
    if (mvpayinfo != null) {
      map["mvpayinfo"] = mvpayinfo.toJson();
    }
    map["pic"] = pic;
    map["isstar"] = isstar;
    map["rid"] = rid;
    map["upPcStr"] = upPcStr;
    map["duration"] = duration;
    map["score100"] = score100;
    map["contentType"] = contentType;
    map["mvPlayCnt"] = mvPlayCnt;
    map["track"] = track;
    map["hasLossless"] = hasLossless;
    map["hasmv"] = hasmv;
    map["releaseDate"] = releaseDate;
    map["album"] = album;
    map["albumid"] = albumid;
    map["pay"] = pay;
    map["artistid"] = artistid;
    map["albumpic"] = albumpic;
    map["songTimeMinutes"] = songTimeMinutes;
    map["isListenFee"] = isListenFee;
    map["mvUpPcStr"] = mvUpPcStr;
    map["pic120"] = pic120;
    map["albuminfo"] = albuminfo;
    map["name"] = name;
    map["online"] = online;
    if (payInfo != null) {
      map["payInfo"] = payInfo.toJson();
    }
    return map;
  }
}

/// play : "1111"
/// download : "1111"
/// cannotDownload : 0
/// cannotOnlinePlay : 0
/// feeType : {"album":"1"}
/// down : "1111"

class PayInfo {
  String play;
  String download;
  int cannotDownload;
  int cannotOnlinePlay;
  FeeType feeType;
  String down;

  PayInfo(
      {this.play,
      this.download,
      this.cannotDownload,
      this.cannotOnlinePlay,
      this.feeType,
      this.down});

  PayInfo.fromJson(dynamic json) {
    play = json["play"];
    download = json["download"];
    cannotDownload = json["cannotDownload"];
    cannotOnlinePlay = json["cannotOnlinePlay"];
    feeType =
        json["feeType"] != null ? FeeType.fromJson(json["feeType"]) : null;
    down = json["down"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["play"] = play;
    map["download"] = download;
    map["cannotDownload"] = cannotDownload;
    map["cannotOnlinePlay"] = cannotOnlinePlay;
    if (feeType != null) {
      map["feeType"] = feeType.toJson();
    }
    map["down"] = down;
    return map;
  }
}

/// album : "1"

class FeeType {
  String album;

  FeeType({this.album});

  FeeType.fromJson(dynamic json) {
    album = json["album"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["album"] = album;
    return map;
  }
}

/// play : 0
/// vid : 0
/// down : 0

class Mvpayinfo {
  int play;
  int vid;
  int down;

  Mvpayinfo({this.play, this.vid, this.down});

  Mvpayinfo.fromJson(dynamic json) {
    play = json["play"];
    vid = json["vid"];
    down = json["down"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["play"] = play;
    map["vid"] = vid;
    map["down"] = down;
    return map;
  }
}
