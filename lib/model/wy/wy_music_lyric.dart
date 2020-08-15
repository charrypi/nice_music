class WySongLyric {
  bool sgc;
  bool sfy;
  bool qfy;
  Lrc lrc;
  Lrc klyric;
  Tlyric tlyric;
  int code;

  WySongLyric(
      {this.sgc,
        this.sfy,
        this.qfy,
        this.lrc,
        this.klyric,
        this.tlyric,
        this.code});

  WySongLyric.fromJson(Map<String, dynamic> json) {
    sgc = json['sgc'];
    sfy = json['sfy'];
    qfy = json['qfy'];
    lrc = json['lrc'] != null ? new Lrc.fromJson(json['lrc']) : null;
    klyric = json['klyric'] != null ? new Lrc.fromJson(json['klyric']) : null;
    tlyric =
    json['tlyric'] != null ? new Tlyric.fromJson(json['tlyric']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sgc'] = this.sgc;
    data['sfy'] = this.sfy;
    data['qfy'] = this.qfy;
    if (this.lrc != null) {
      data['lrc'] = this.lrc.toJson();
    }
    if (this.klyric != null) {
      data['klyric'] = this.klyric.toJson();
    }
    if (this.tlyric != null) {
      data['tlyric'] = this.tlyric.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Lrc {
  int version;
  String lyric;

  Lrc({this.version, this.lyric});

  Lrc.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    lyric = json['lyric'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['lyric'] = this.lyric;
    return data;
  }
}

class Tlyric {
  int version;
  String lyric;

  Tlyric({this.version, this.lyric});

  Tlyric.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    lyric = json['lyric'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['lyric'] = this.lyric;
    return data;
  }
}
