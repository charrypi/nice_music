import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/db/downloadlist_dao.dart';
import 'package:nicemusic/exception/download_exception.dart';
import 'package:nicemusic/exception/parse_exception.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/kw/kw_music_info.dart';
import 'package:nicemusic/model/abstract_query.dart';
import 'package:nicemusic/model/kw/kw_music_list.dart';
import 'package:nicemusic/model/kw/suggestion.dart';
import 'package:nicemusic/model/song_query.dart';
import 'package:nicemusic/util/request.dart';
import 'package:path_provider/path_provider.dart';

class KwRequestApi implements PlatformApi {
  String token;

  @override
  Future getAlbumPic(Map<String, dynamic> params) async {
    Response response = await HttpRequest.getInstance().get(
        "http://artistpicserver.kuwo.cn/pic.web?corp=kuwo&type=rid_pic&pictype=500&size=500&rid=${params['id']}");
    if (HttpStatus.ok == response.statusCode) {
      return response.data;
    }
    return null;
  }

  @override
  Future getLyric(Map<String, dynamic> params) async {
    try {
      Response response = await HttpRequest.getInstance().get(
          "http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=MUSIC_${params['id']}");
      if (HttpStatus.ok == response.statusCode) {
        RegExp reg = RegExp("<lyric>(.+?)<\/lyric>");
        Iterable<Match> matches = reg.allMatches(response.data);
        // 匹配到歌词key
        String lyricCode = matches.map((e) => e.group(1)).toList()[0];
        // 此处获取字节数组
        Response<List<int>> lyricResp = await HttpRequest.getInstance()
            .get<List<int>>("http://newlyric.kuwo.cn/newlyric.lrc?$lyricCode",
                options: Options(responseType: ResponseType.bytes));
        if (lyricResp.statusCode == HttpStatus.ok) {
          /// 酷我歌词解析过程
          List<int> raw = lyricResp.data;
          String str = String.fromCharCodes(raw);
          // 去掉头部介绍内容，返回二进制歌词
          String byteArrStr = str.substring(str.indexOf('\r\n\r\n') + 4);
          List<int> inflated = zlib.decode(byteArrStr.codeUnits);
          String lyric = gbk.decode(inflated);
          return lyric;
        }
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
          "http://search.kuwo.cn/r.s?client=kt&all=$queryStr&pn=${query.page - 1}&rn=${query.rows}&uid=794762570&ver=kwplayer_ar_9.2.2.1&vipver=1&show_copyright_off=1&newver=1&ft=music&cluster=0&strategy=2012&encoding=utf8&rformat=json&vermerge=1&mobi=1&issubtitle=1");
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.data);
        KwMusicList list = KwMusicList.fromJson(data);
        return list;
      }
    } catch (e, s) {
      print(s);
      return null;
    }
  }

  // 获取音乐详细信息
  Future _getMusicInfo(int mid) async {
    this.token = await getToken();
    Options options = Options(headers: {
      'Referer': 'http://www.kuwo.cn/',
      'csrf': token,
      'cookie': 'kw_token=' + token,
    });
    Response response = await HttpRequest.getInstance().get(
        "http://www.kuwo.cn/api/www/music/musicInfo?mid=$mid",
        options: options);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> data = json.decode(response.data);
      KwMusicInfo info = KwMusicInfo.fromJson(data);
      return info;
    }
    return null;
  }

  @override
  Future getPlayUrl(Map<String, dynamic> params) async {
    try {
      Response response = await HttpRequest.getInstance().get(
          "http://antiserver.kuwo.cn/anti.s?response=url&rid=MUSIC_${params['id']}&format=mp3&type=convert_url");
      if (HttpStatus.ok == response.statusCode) {
        return response.data;
      }
    } catch (e) {
      throw ParseException();
    }
  }

  // 获取搜索建议列表
  Future getSuggestions(String keyword) async {
    List<String> suggestions = List();
    this.token = await getToken();
    Map<String, dynamic> params = {'key': keyword};
    Options options = Options(headers: {
      'Referer': 'http://www.kuwo.cn/',
      'csrf': token,
      'cookie': 'kw_token=' + token,
    });
    Response response = await HttpRequest.getInstance().get(
        "http://www.kuwo.cn/api/www/search/searchKey",
        params: params,
        options: options);
    if (response.statusCode == HttpStatus.ok) {
      Suggestion suggestion = Suggestion.fromJson(response.data);
      List<String> datas = suggestion.data;
      datas.forEach((data) {
        String relword = data.split('\r\n')[0];
        suggestions.add(relword.substring(relword.indexOf('=') + 1));
      });
    }
    return suggestions;
  }

  // 获取token
  getToken() async {
    if (token == null) {
      Response response = await HttpRequest.getInstance()
          .get("http://www.kuwo.cn/", params: {
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
      });
      if (response.statusCode == HttpStatus.ok) {
        List<String> cookies =
            response.headers[HttpHeaders.setCookieHeader][0].split(";");
        for (String s in cookies) {
          if (s.startsWith("kw_token=")) {
            this.token = s.substring(s.indexOf("=") + 1);
          }
        }
      }
    }
    return this.token;
  }

  @override
  Future downloadFile(
      DownloadListModel model, ProgressCallback receiveProgress) async{
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
