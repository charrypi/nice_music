/// ARTISTPIC : ""
/// HIT : "3112"
/// HITMODE : "song"
/// HIT_BUT_OFFLINE : "0"
/// MSHOW : "0"
/// NEW : "0"
/// PN : "0"
/// RN : "1"
/// SHOW : "1"
/// TOTAL : "3112"
/// abslist : [{"AARTIST":"Jay Chou","ALBUM":"Mojito","ALBUMID":"14365066","ALIAS":"","ARTIST":"周杰伦","ARTISTID":"336","CanSetRing":"1","CanSetRingback":"1","DURATION":"185","FARTIST":"周杰伦","FORMAT":"wma","FSONGNAME":"","KMARK":"0","MINFO":"level:ff,bitrate:2000,format:flac,size:19.88Mb;level:pp,bitrate:1000,format:ape,size:19.25Mb;level:p,bitrate:320,format:mp3,size:7.6Mb;level:h,bitrate:192,format:mp3,size:4.23Mb;level:s,bitrate:48,format:aac,size:543.16Kb","MUSICRID":"MUSIC_142655450","MVFLAG":"1","MVPIC":"324/94/21/3715555916.jpg","MVQUALITY":"MP4;MP4L","NAME":"Mojito","NEW":"0","ONLINE":"1","PAY":"255","PROVIDER":"","SONGNAME":"Mojito","SUBLIST":[],"SUBTITLE":"","TAG":"http://w04.funmtv.com/Wmam/Z/20051031/1246/1.Wma","audiobookpayinfo":{"download":"0","play":"0"},"cache_status":"1","content_type":"0","fpay":"0","hts_MVPIC":"https://img4.kuwo.cn/wmvpic/324/94/21/3715555916.jpg","iot_info":"B_0,D_0,G_0,H_0,A_14","isdownload":"0","isshowtype":"0","isstar":"0","mvpayinfo":{"download":"0","play":"0","vid":"8866410"},"nationid":"0","opay":"0","originalsongtype":"1","overseas_copyright":"7ffffffffffffffffffffbfffffffffffffffffffffffffffffffff","overseas_pay":"16711935","payInfo":{"cannotDownload":"0","cannotOnlinePlay":"0","download":"1111","feeType":{"album":"1","bookvip":"0","song":"0","vip":"0"},"listen_fragment":"0","local_encrypt":"0","play":"1111","tips_intercept":"0"},"react_type":"","terminal":"1,2,3","tpay":"0"}]
/// searchgroup : "englishcorrect"

class KwMusicList {
  String ARTISTPIC;
  String HIT;
  String HITMODE;
  String HITBUTOFFLINE;
  String MSHOW;
  String NEW;
  String PN;
  String RN;
  String SHOW;
  String TOTAL;
  List<Abslist> abslist;
  String searchgroup;

  KwMusicList(
      {this.ARTISTPIC,
      this.HIT,
      this.HITMODE,
      this.HITBUTOFFLINE,
      this.MSHOW,
      this.NEW,
      this.PN,
      this.RN,
      this.SHOW,
      this.TOTAL,
      this.abslist,
      this.searchgroup});

  KwMusicList.fromJson(Map<String, dynamic> json) {
    ARTISTPIC = json["ARTISTPIC"];
    HIT = json["HIT"];
    HITMODE = json["HITMODE"];
    HITBUTOFFLINE = json["HITBUTOFFLINE"];
    MSHOW = json["MSHOW"];
    NEW = json["NEW"];
    PN = json["PN"];
    RN = json["RN"];
    SHOW = json["SHOW"];
    TOTAL = json["TOTAL"];
    if (json["abslist"] != null) {
      abslist = [];
      json["abslist"].forEach((v) {
        abslist.add(Abslist.fromJson(v));
      });
    }
    searchgroup = json["searchgroup"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ARTISTPIC"] = ARTISTPIC;
    map["HIT"] = HIT;
    map["HITMODE"] = HITMODE;
    map["HITBUTOFFLINE"] = HITBUTOFFLINE;
    map["MSHOW"] = MSHOW;
    map["NEW"] = NEW;
    map["PN"] = PN;
    map["RN"] = RN;
    map["SHOW"] = SHOW;
    map["TOTAL"] = TOTAL;
    if (abslist != null) {
      map["abslist"] = abslist.map((v) => v.toJson()).toList();
    }
    map["searchgroup"] = searchgroup;
    return map;
  }
}

/// AARTIST : "Jay Chou"
/// ALBUM : "Mojito"
/// ALBUMID : "14365066"
/// ALIAS : ""
/// ARTIST : "周杰伦"
/// ARTISTID : "336"
/// CanSetRing : "1"
/// CanSetRingback : "1"
/// DURATION : "185"
/// FARTIST : "周杰伦"
/// FORMAT : "wma"
/// FSONGNAME : ""
/// KMARK : "0"
/// MINFO : "level:ff,bitrate:2000,format:flac,size:19.88Mb;level:pp,bitrate:1000,format:ape,size:19.25Mb;level:p,bitrate:320,format:mp3,size:7.6Mb;level:h,bitrate:192,format:mp3,size:4.23Mb;level:s,bitrate:48,format:aac,size:543.16Kb"
/// MUSICRID : "MUSIC_142655450"
/// MVFLAG : "1"
/// MVPIC : "324/94/21/3715555916.jpg"
/// MVQUALITY : "MP4;MP4L"
/// NAME : "Mojito"
/// NEW : "0"
/// ONLINE : "1"
/// PAY : "255"
/// PROVIDER : ""
/// SONGNAME : "Mojito"
/// SUBLIST : []
/// SUBTITLE : ""
/// TAG : "http://w04.funmtv.com/Wmam/Z/20051031/1246/1.Wma"
/// audiobookpayinfo : {"download":"0","play":"0"}
/// cache_status : "1"
/// content_type : "0"
/// fpay : "0"
/// hts_MVPIC : "https://img4.kuwo.cn/wmvpic/324/94/21/3715555916.jpg"
/// iot_info : "B_0,D_0,G_0,H_0,A_14"
/// isdownload : "0"
/// isshowtype : "0"
/// isstar : "0"
/// mvpayinfo : {"download":"0","play":"0","vid":"8866410"}
/// nationid : "0"
/// opay : "0"
/// originalsongtype : "1"
/// overseas_copyright : "7ffffffffffffffffffffbfffffffffffffffffffffffffffffffff"
/// overseas_pay : "16711935"
/// payInfo : {"cannotDownload":"0","cannotOnlinePlay":"0","download":"1111","feeType":{"album":"1","bookvip":"0","song":"0","vip":"0"},"listen_fragment":"0","local_encrypt":"0","play":"1111","tips_intercept":"0"}
/// react_type : ""
/// terminal : "1,2,3"
/// tpay : "0"

class Abslist {
  String AARTIST;
  String ALBUM;
  String ALBUMID;
  String ALIAS;
  String ARTIST;
  String ARTISTID;
  String CanSetRing;
  String CanSetRingback;
  String DURATION;
  String FARTIST;
  String FORMAT;
  String FSONGNAME;
  String KMARK;
  String MINFO;
  String MUSICRID;
  String MVFLAG;
  String MVPIC;
  String MVQUALITY;
  String NAME;
  String NEW;
  String ONLINE;
  String PAY;
  String PROVIDER;
  String SONGNAME;
  List<String> SUBLIST;
  String SUBTITLE;
  String TAG;
  Audiobookpayinfo audiobookpayinfo;
  String cache_status;
  String content_type;
  String fpay;
  String hts_MVPIC;
  String iot_info;
  String isdownload;
  String isshowtype;
  String isstar;
  Mvpayinfo mvpayinfo;
  String nationid;
  String opay;
  String originalsongtype;
  String overseasCopyright;
  String overseasPay;
  PayInfo payInfo;
  String reactType;
  String terminal;
  String tpay;

  Abslist(
      {this.AARTIST,
      this.ALBUM,
      this.ALBUMID,
      this.ALIAS,
      this.ARTIST,
      this.ARTISTID,
      this.CanSetRing,
      this.CanSetRingback,
      this.DURATION,
      this.FARTIST,
      this.FORMAT,
      this.FSONGNAME,
      this.KMARK,
      this.MINFO,
      this.MUSICRID,
      this.MVFLAG,
      this.MVPIC,
      this.MVQUALITY,
      this.NAME,
      this.NEW,
      this.ONLINE,
      this.PAY,
      this.PROVIDER,
      this.SONGNAME,
      this.SUBLIST,
      this.SUBTITLE,
      this.TAG,
      this.audiobookpayinfo,
      this.cache_status,
      this.content_type,
      this.fpay,
      this.hts_MVPIC,
      this.iot_info,
      this.isdownload,
      this.isshowtype,
      this.isstar,
      this.mvpayinfo,
      this.nationid,
      this.opay,
      this.originalsongtype,
      this.overseasCopyright,
      this.overseasPay,
      this.payInfo,
      this.reactType,
      this.terminal,
      this.tpay});

  Abslist.fromJson(dynamic json) {
    AARTIST = json["AARTIST"];
    ALBUM = json["ALBUM"];
    ALBUMID = json["ALBUMID"];
    ALIAS = json["ALIAS"];
    ARTIST = json["ARTIST"];
    ARTISTID = json["ARTISTID"];
    CanSetRing = json["CanSetRing"];
    CanSetRingback = json["CanSetRingback"];
    DURATION = json["DURATION"];
    FARTIST = json["FARTIST"];
    FORMAT = json["FORMAT"];
    FSONGNAME = json["FSONGNAME"];
    KMARK = json["KMARK"];
    MINFO = json["MINFO"];
    MUSICRID = json["MUSICRID"];
    MVFLAG = json["MVFLAG"];
    MVPIC = json["MVPIC"];
    MVQUALITY = json["MVQUALITY"];
    NAME = json["NAME"];
    NEW = json["NEW"];
    ONLINE = json["ONLINE"];
    PAY = json["PAY"];
    PROVIDER = json["PROVIDER"];
    SONGNAME = json["SONGNAME"];
    if (json["SUBLIST"] != null) {
      SUBLIST = [];
      json["SUBLIST"].forEach((v) {
//        SUBLIST.add(v);
      });
    }
    SUBTITLE = json["SUBTITLE"];
    TAG = json["TAG"];
    audiobookpayinfo = json["audiobookpayinfo"] != null
        ? Audiobookpayinfo.fromJson(json["audiobookpayinfo"])
        : null;
    cache_status = json["cache_status"];
    content_type = json["content_type"];
    fpay = json["fpay"];
    hts_MVPIC = json["hts_MVPIC"];
    iot_info = json["iot_info"];
    isdownload = json["isdownload"];
    isshowtype = json["isshowtype"];
    isstar = json["isstar"];
    mvpayinfo = json["mvpayinfo"] != null
        ? Mvpayinfo.fromJson(json["mvpayinfo"])
        : null;
    nationid = json["nationid"];
    opay = json["opay"];
    originalsongtype = json["originalsongtype"];
    overseasCopyright = json["overseasCopyright"];
    overseasPay = json["overseasPay"];
    payInfo =
        json["payInfo"] != null ? PayInfo.fromJson(json["payInfo"]) : null;
    reactType = json["reactType"];
    terminal = json["terminal"];
    tpay = json["tpay"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["AARTIST"] = AARTIST;
    map["ALBUM"] = ALBUM;
    map["ALBUMID"] = ALBUMID;
    map["ALIAS"] = ALIAS;
    map["ARTIST"] = ARTIST;
    map["ARTISTID"] = ARTISTID;
    map["CanSetRing"] = CanSetRing;
    map["CanSetRingback"] = CanSetRingback;
    map["DURATION"] = DURATION;
    map["FARTIST"] = FARTIST;
    map["FORMAT"] = FORMAT;
    map["FSONGNAME"] = FSONGNAME;
    map["KMARK"] = KMARK;
    map["MINFO"] = MINFO;
    map["MUSICRID"] = MUSICRID;
    map["MVFLAG"] = MVFLAG;
    map["MVPIC"] = MVPIC;
    map["MVQUALITY"] = MVQUALITY;
    map["NAME"] = NAME;
    map["NEW"] = NEW;
    map["ONLINE"] = ONLINE;
    map["PAY"] = PAY;
    map["PROVIDER"] = PROVIDER;
    map["SONGNAME"] = SONGNAME;
    if (SUBLIST != null) {
//      map["SUBLIST"] = SUBLIST.map((v) => v.toJson()).toList();
    }
    map["SUBTITLE"] = SUBTITLE;
    map["TAG"] = TAG;
    if (audiobookpayinfo != null) {
      map["audiobookpayinfo"] = audiobookpayinfo.toJson();
    }
    map["cache_status"] = cache_status;
    map["content_type"] = content_type;
    map["fpay"] = fpay;
    map["hts_MVPIC"] = hts_MVPIC;
    map["iot_info"] = iot_info;
    map["isdownload"] = isdownload;
    map["isshowtype"] = isshowtype;
    map["isstar"] = isstar;
    if (mvpayinfo != null) {
      map["mvpayinfo"] = mvpayinfo.toJson();
    }
    map["nationid"] = nationid;
    map["opay"] = opay;
    map["originalsongtype"] = originalsongtype;
    map["overseasCopyright"] = overseasCopyright;
    map["overseasPay"] = overseasPay;
    if (payInfo != null) {
      map["payInfo"] = payInfo.toJson();
    }
    map["reactType"] = reactType;
    map["terminal"] = terminal;
    map["tpay"] = tpay;
    return map;
  }
}

/// cannotDownload : "0"
/// cannotOnlinePlay : "0"
/// download : "1111"
/// feeType : {"album":"1","bookvip":"0","song":"0","vip":"0"}
/// listen_fragment : "0"
/// local_encrypt : "0"
/// play : "1111"
/// tips_intercept : "0"

class PayInfo {
  String cannotDownload;
  String cannotOnlinePlay;
  String download;
  FeeType feeType;
  String listenFragment;
  String localEncrypt;
  String play;
  String tipsIntercept;

  PayInfo(
      {this.cannotDownload,
      this.cannotOnlinePlay,
      this.download,
      this.feeType,
      this.listenFragment,
      this.localEncrypt,
      this.play,
      this.tipsIntercept});

  PayInfo.fromJson(dynamic json) {
    cannotDownload = json["cannotDownload"];
    cannotOnlinePlay = json["cannotOnlinePlay"];
    download = json["download"];
    feeType =
        json["feeType"] != null ? FeeType.fromJson(json["feeType"]) : null;
    listenFragment = json["listenFragment"];
    localEncrypt = json["localEncrypt"];
    play = json["play"];
    tipsIntercept = json["tipsIntercept"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cannotDownload"] = cannotDownload;
    map["cannotOnlinePlay"] = cannotOnlinePlay;
    map["download"] = download;
    if (feeType != null) {
      map["feeType"] = feeType.toJson();
    }
    map["listenFragment"] = listenFragment;
    map["localEncrypt"] = localEncrypt;
    map["play"] = play;
    map["tipsIntercept"] = tipsIntercept;
    return map;
  }
}

/// album : "1"
/// bookvip : "0"
/// song : "0"
/// vip : "0"

class FeeType {
  String album;
  String bookvip;
  String song;
  String vip;

  FeeType({this.album, this.bookvip, this.song, this.vip});

  FeeType.fromJson(dynamic json) {
    album = json["album"];
    bookvip = json["bookvip"];
    song = json["song"];
    vip = json["vip"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["album"] = album;
    map["bookvip"] = bookvip;
    map["song"] = song;
    map["vip"] = vip;
    return map;
  }
}

/// download : "0"
/// play : "0"
/// vid : "8866410"

class Mvpayinfo {
  String download;
  String play;
  String vid;

  Mvpayinfo({this.download, this.play, this.vid});

  Mvpayinfo.fromJson(dynamic json) {
    download = json["download"];
    play = json["play"];
    vid = json["vid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["download"] = download;
    map["play"] = play;
    map["vid"] = vid;
    return map;
  }
}

/// download : "0"
/// play : "0"

class Audiobookpayinfo {
  String download;
  String play;

  Audiobookpayinfo({this.download, this.play});

  Audiobookpayinfo.fromJson(dynamic json) {
    download = json["download"];
    play = json["play"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["download"] = download;
    map["play"] = play;
    return map;
  }
}
