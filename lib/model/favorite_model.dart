/// 收藏歌曲模型，和数据库模型一致
class FavoriteModel {
  // 主键
  int fid;

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

  FavoriteModel(
      {this.fid,
      this.sid,
      this.mid,
      this.sname,
      this.artists,
      this.albumId,
      this.albumName,
      this.albumPic,
      this.source});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    sid = json['sid'];
    mid = json['mid'];
    sname = json['sname'];
    artists = json['artists'];
    albumName = json['albumName'];
    albumId = json['albumId'];
    albumPic = json['albumPic'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['fid'] = fid;
    data['sid'] = sid;
    data['mid'] = mid;
    data['sname'] = sname;
    data['artists'] = artists;
    data['albumId'] = albumId;
    data['albumName'] = albumName;
    data['albumPic'] = albumPic;
    data['source'] = source;
    return data;
  }
}
