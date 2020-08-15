/// retcode : 0
/// code : 0
/// subcode : 0
/// lyric : "[ti:体面 (Live)]\n[ar:于文文]\n[al:翻牌大明星 第4期]\n[by:]\n[offset:0]\n[00:00.00]体面 (Live) - 于文文 (Kelly)\n[00:08.01]词：唐恬\n[00:16.03]曲：于文文\n[00:24.05]别堆砌怀念让剧情 变得狗血\n[00:35.36]深爱了多年又何必 毁了经典\n[00:44.13]都已成年不拖不欠\n[00:49.77]浪费时间是我情愿\n[00:55.33]像谢幕的演员 眼看着灯光熄灭\n[01:06.77]来不及 再轰轰烈烈\n[01:12.24]就保留 告别的尊严\n[01:17.96]我爱你不后悔 也尊重故事结尾\n[01:29.32]分手应该体面 谁都不用说抱歉\n[01:36.23]何来亏欠 我敢给就敢心碎\n[01:41.97]镜头前面是从前的我们\n[01:46.51]在喝彩 流着泪声嘶力竭\n[01:51.90]离开也很体面 才没辜负这些年\n[01:58.79]爱得热烈 认真付出的画面\n[02:04.54]别让执念 毁掉了昨天\n[02:09.12]我爱过你 利落干脆\n[02:36.66]最熟悉的街主角却 换了人演\n[02:48.06]我哭到哽咽心再痛 就当破茧\n[02:56.76]来不及 再轰轰烈烈\n[03:02.36]就保留 告别的尊严\n[03:08.16]我爱你不后悔 也尊重故事结尾\n[03:19.40]分手应该体面 谁都不用说抱歉\n[03:26.36]何来亏欠 我敢给就敢心碎\n[03:32.03]镜头前面是从前的我们\n[03:36.61]在喝彩 流着泪声嘶力竭\n[03:42.02]离开也很体面 才没辜负这些年\n[03:48.93]爱得热烈 认真付出的画面\n[03:54.57]别让执念 毁掉了昨天\n[03:59.20]我爱过你 利落干脆\n[04:05.29]再见 不负遇见"
/// trans : ""

class TxMusicLyric {
  int retcode;
  int code;
  int subcode;
  String lyric;
  String trans;

  TxMusicLyric({this.retcode, this.code, this.subcode, this.lyric, this.trans});

  TxMusicLyric.fromJson(Map<String, dynamic> json) {
    retcode = json["retcode"];
    code = json["code"];
    subcode = json["subcode"];
    lyric = json["lyric"];
    trans = json["trans"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["retcode"] = retcode;
    map["code"] = code;
    map["subcode"] = subcode;
    map["lyric"] = lyric;
    map["trans"] = trans;
    return map;
  }
}
