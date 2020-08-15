import 'package:flutter/foundation.dart';
import 'package:nicemusic/db/favorite_dao.dart';
import 'package:nicemusic/model/favorite_model.dart';
import 'package:nicemusic/model/favorite_query.dart';

class FavoriteListNotifier with ChangeNotifier {
  List<FavoriteModel> _favorites = List();

  List<FavoriteModel> get favorites => this._favorites;

  FavoriteListNotifier() {
    _initDatas();
  }

  add(FavoriteModel model) async {
    this._favorites.add(model);
    await saveFavorite(model.toJson());
    notifyListeners();
  }

  remove({sid, source}) async {
    this._favorites.removeWhere((f) => f.sid == sid && f.source == source);
    await removeFavorite(sid: sid, source: source);
    notifyListeners();
  }

  checkExist({sid, source}) {
    int index =
        _favorites.indexWhere((f) => f.sid == sid && f.source == source);
    return index > -1 ? true : false;
  }

  _initDatas() async {
    FavoriteQuery query = FavoriteQuery();
    query.rows = -1;
    query = await queryFavoriteList(query);
    _favorites = query.result;
  }
}
