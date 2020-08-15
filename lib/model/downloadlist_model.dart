/// 下载列表模型，和数据库模型一致
class DownloadListModel {
  // 主键
  int did;

  // 歌曲id
  int sid;

  // 歌曲唯一标识
  String mid;

  // 歌名
  String sname;

  // 作者
  String artists;

  // 专辑主键
  String albumId;

  // 专辑名
  String albumName;

  // 专辑图片
  String albumPic;

  // 来源
  String source;

  // 文件大小
  int fileSize;

  // 本地路径
  String localPath;

  DownloadListModel(
      {this.did,
      this.sid,
      this.mid,
      this.sname,
      this.artists,
      this.albumId,
      this.albumName,
      this.albumPic,
      this.source,
      this.fileSize,
      this.localPath});

  DownloadListModel.fromJson(Map<String, dynamic> json) {
    did = json['did'];
    sid = json['sid'];
    mid = json['mid'];
    sname = json['sname'];
    artists = json['artists'];
    albumId = json['albumId'];
    albumName = json['albumName'];
    albumPic = json['albumPic'];
    source = json['source'];
    fileSize = json['fileSize'];
    localPath = json['localPath'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['did'] = did;
    data['sid'] = sid;
    data['mid'] = mid;
    data['sname'] = sname;
    data['artists'] = artists;
    data['albumId'] = albumId;
    data['albumName'] = albumName;
    data['albumPic'] = albumPic;
    data['source'] = source;
    data['fileSize'] = fileSize;
    data['localPath'] = localPath;
    return data;
  }
}
