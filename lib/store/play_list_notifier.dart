import 'package:flutter/foundation.dart';
import 'package:nicemusic/db/playlist_dao.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/model/playlist_query.dart';

// 播放列表Provider
class PlayListNotifier with ChangeNotifier {
  // 播放列表数据
  List<PlayListModel> _playList = List();

  List<PlayListModel> get playList => this._playList;

  PlayListNotifier() {
    _initPlayList();
  }

  // 更新播放列表
  updatePlayList(List<PlayListModel> playList) {
    this._playList = playList;
    notifyListeners();
  }

  remove(PlayListModel model) {
    this._playList.removeWhere((m) => m.pid == model.pid);
    notifyListeners();
  }

  _initPlayList() async {
    PlayListQuery query = PlayListQuery();
    query.rows = -1;
    query = await queryPlayList(query);
    this._playList = query.result;
    notifyListeners();
  }
}
