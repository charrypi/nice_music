import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/db/downloadlist_dao.dart';
import 'package:nicemusic/exception/download_exception.dart';
import 'package:nicemusic/exception/illegal_data_exception.dart';
import 'package:nicemusic/exception/parse_exception.dart';
import 'package:nicemusic/model/abstract_query.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/tx/tx_music_list.dart';

import 'package:nicemusic/model/song_query.dart';
import 'package:nicemusic/model/tx/tx_music_lyric.dart';
import 'package:nicemusic/model/tx/tx_play_url.dart';
import 'package:nicemusic/util/request.dart';
import 'package:path_provider/path_provider.dart';

class TxRequestApi implements PlatformApi {
  final int success = 0;

  final HttpRequest request = HttpRequest.getInstance();

  @override
  Future getAlbumPic(Map<String, dynamic> params) async {
    return 'https://y.gtimg.cn/music/photo_new/T002R500x500M000${params['albumId']}.jpg';
  }

  @override
  Future getLyric(Map<String, dynamic> params) async {
    try {
      Options options =
          Options(headers: {'Referer': 'https://y.qq.com/portal/player.html'});
      Response response = await request.get(
          "https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg?songmid=${params['mid']}&format=json&nobase64=1",
          options: options);
      if (response.statusCode == HttpStatus.ok) {
        TxMusicLyric musicLyric =
            TxMusicLyric.fromJson(json.decode(response.data));
        return musicLyric.lyric;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future getPageList(Query query) async {
    SongQuery songQuery = query;
    final data = songQuery.conditions;
    try {
      String queryStr = Uri.encodeComponent(data['queryStr']);
      Response response = await HttpRequest.getInstance().get(
          "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?ct=24&qqmusic_ver=1298&new_json=1&remoteplace=sizer.yqq.song_next&searchid=49252838123499591&t=0&aggr=1&cr=1&catZhida=1&lossless=0&flag_qc=0&p=${query.page}&n=${query.rows}&w=$queryStr&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8&notice=0&platform=yqq&needNewCode=0");
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.data);
        TxMusicList musicList = TxMusicList.fromJson(data);
        if (musicList.code == 0) {
          return musicList;
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    return null;
  }

  @override
  Future getPlayUrl(Map<String, dynamic> params) async {
    try {
      Response response = await HttpRequest.getInstance().get(
          "https://u.y.qq.com/cgi-bin/musicu.fcg?format=json&data=%7B%22req_0%22%3A%7B%22module%22%3A%22vkey.GetVkeyServer%22%2C%22method%22%3A%22CgiGetVkey%22%2C%22param%22%3A%7B%22guid%22%3A%22358840384%22%2C%22songmid%22%3A%5B%22${params['mid']}%22%5D%2C%22songtype%22%3A%5B0%5D%2C%22uin%22%3A%221443481947%22%2C%22loginflag%22%3A1%2C%22platform%22%3A%2220%22%7D%7D%2C%22comm%22%3A%7B%22uin%22%3A%2218585073516%22%2C%22format%22%3A%22json%22%2C%22ct%22%3A24%2C%22cv%22%3A0%7D%7D",
          options: Options(responseType: ResponseType.plain));
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.data);
        TxPlayUrl playUrl = TxPlayUrl.fromJson(data);
        if (playUrl.code == 0) {
          String pre = playUrl.req0.data.sip[0];
          String sub = playUrl.req0.data.midurlinfo[0].purl;
          if (sub == null || sub.isEmpty) {
            throw IllegalDataException();
          }
          return pre + sub;
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
      throw ParseException();
    }
  }

  @override
  Future downloadFile(
      DownloadListModel model, ProgressCallback receiveProgress) async {
    Map<String, dynamic> params = {
      'id': model.sid,
      'mid': model.mid,
      'albumId': model.albumId
    };
    try {
      String url = await getPlayUrl(params);
      String albumPic = await getAlbumPic(params);
      model.albumPic = albumPic;
      Directory directory = await getTemporaryDirectory();
      String cachePath = directory.path;
      String fileName = model.artists + '-' + model.sname + '.m4a';
      String savePath = cachePath + '/' + fileName;

      Response response = await HttpRequest.getInstance()
          .download(url, savePath, receiveProgress);
      // 保存到已下载列表
      model.localPath = savePath;
      model.fileSize =
          int.parse(response.headers.value(Headers.contentLengthHeader));
      // 添加数据到下载列表
      return await addDownloadList(model);
    } catch (e) {
      print(e);
      throw DownLoadException();
    }
  }
}
