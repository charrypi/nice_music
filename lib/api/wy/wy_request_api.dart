import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/api/wy/answer.dart';
import 'package:nicemusic/db/downloadlist_dao.dart';
import 'package:nicemusic/exception/download_exception.dart';
import 'package:nicemusic/exception/illegal_data_exception.dart';
import 'package:nicemusic/exception/parse_exception.dart';
import 'package:nicemusic/model/abstract_query.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/wy/wy_music_lyric.dart';
import 'package:nicemusic/model/wy/wy_music_model.dart';
import 'package:nicemusic/model/wy/wy_song_detail.dart';
import 'package:nicemusic/model/wy/wy_song_url.dart';
import 'package:nicemusic/util/request.dart';
import 'package:path_provider/path_provider.dart';

import 'request.dart';
import 'package:nicemusic/model/song_query.dart';

class WyRequestApi implements PlatformApi {
  @override
  Future getAlbumPic(Map<String, dynamic> params) async {
    Cookie cookie =
        Cookie("now", DateTime.now().millisecondsSinceEpoch.toString());
    List<Cookie> cookies = List();
    cookies.add(cookie);
    final aq = {
      'ids': ['${params['id']}']
    };
    final data = {
      'c': '[' + aq['ids'].map((id) => ('{"id":' + id + '}')).join(',') + ']',
      'ids': '[' + aq['ids'].join(',') + ']'
    };
    try {
      Answer answer = await request(
          'POST', 'https://music.163.com/weapi/v3/song/detail', data,
          crypto: Crypto.weapi, cookies: cookies);
      if (answer.status == HttpStatus.ok) {
        WySongDetail detail = WySongDetail.fromJson(answer.body);
        return detail.songs[0].al.picUrl;
      } else {
        return null;
      }
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  @override
  Future getLyric(Map<String, dynamic> params) async {
    final data = {'id': params['id']};
    Cookie cookie =
        Cookie("now", DateTime.now().millisecondsSinceEpoch.toString());
    List<Cookie> cookies = List();
    cookies.add(cookie);
    try {
      Answer answer = await request('POST',
          'https://music.163.com/weapi/song/lyric?lv=-1&kv=-1&tv=-1', data,
          crypto: Crypto.linuxapi, cookies: cookies, ua: 'pc');
      if (answer.status == HttpStatus.ok) {
        WySongLyric lyric = WySongLyric.fromJson(answer.body);
        return lyric.lrc.lyric;
      } else {
        return null;
      }
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  @override
  Future getPageList(Query query) async {
    SongQuery sQuery = query;
    final data = sQuery.conditions;
    try {
      Answer answer = await request(
          'POST', 'https://music.163.com/weapi/search/get', data,
          crypto: Crypto.weapi, cookies: []);
      if (answer.status == HttpStatus.ok) {
        WyMusicModel model = WyMusicModel.fromJson(answer.body);
        return model;
      } else {
        return null;
      }
    } catch (e, s) {
      print(s);
      return null;
    }
  }

  @override
  Future getPlayUrl(Map<String, dynamic> params) async {
    Cookie cookie =
        Cookie("now", DateTime.now().millisecondsSinceEpoch.toString());
    List<Cookie> cookies = List();
    cookies.add(cookie);
    try {
      Answer answer = await request(
          'POST',
          'https://music.163.com/weapi/song/enhance/player/url',
          {
            'ids': '[${params['id']}]',
            'br': int.parse(params['br'] ?? '999000'),
          },
          crypto: Crypto.weapi,
          cookies: cookies);
      WySongUrl songUrl = WySongUrl.fromJson(answer.body);
      if (songUrl.code == HttpStatus.ok) {
        String url = songUrl.data[0].url;
        if (url == null || url.isEmpty) {
          throw IllegalDataException();
        }
        return url;
      }
    } catch (e) {
      throw ParseException();
    }
  }

  @override
  Future downloadFile(
      DownloadListModel model, ProgressCallback receiveProgress) async {
    Map<String, dynamic> params = {'id': model.sid};
    try {
      String url = await getPlayUrl(params);
      String albumPic = await getAlbumPic(params);
      model.albumPic = albumPic;
      Directory directory = await getTemporaryDirectory();
      String cachePath = directory.path;
      String fileName = model.artists +
          '-' +
          model.sname +
          url.substring(url.lastIndexOf('.'));
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
