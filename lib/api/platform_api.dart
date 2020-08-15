import 'package:dio/dio.dart';
import 'package:nicemusic/model/abstract_query.dart';
import 'package:nicemusic/model/downloadlist_model.dart';

///平台api接口类
abstract class PlatformApi {
  // 获取分页列表
  Future getPageList(Query query);

  // 获取专辑图片
  Future getAlbumPic(Map<String, dynamic> params);

  // 获取歌词
  Future getLyric(Map<String, dynamic> params);

  // 获取播放地址
  Future getPlayUrl(Map<String, dynamic> params);

  // 下载文件
  Future downloadFile(DownloadListModel model, ProgressCallback receiveProgress);
}
