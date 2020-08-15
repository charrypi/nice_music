import 'package:sqflite/sqflite.dart';
import 'package:nicemusic/util/db_util.dart';
import 'package:nicemusic/model/favorite_query.dart';
import 'package:nicemusic/model/favorite_model.dart';

const String table = "song_favorite";

// 查询列表
Future<FavoriteQuery> queryFavoriteList(FavoriteQuery query) async {
  Database db = await DbUtil.getInstance().getDb();
  List<Map<String, dynamic>> result = await db.query(table,
      limit: query.rows == -1 ? null : query.rows,
      offset: query.rows == -1 ? null : (query.page - 1) * query.rows,
      orderBy: 'fid desc');
  List<FavoriteModel> favorites = List();
  result.forEach((r) {
    favorites.add(FavoriteModel.fromJson(r));
  });
  int total = await getFavoriteTotal(query);
  query.result = favorites;
  query.total = total;
  return query;
}

// 获取收藏的总个数
Future<int> getFavoriteTotal(FavoriteQuery query) async{
  Database db = await DbUtil.getInstance().getDb();
  int count = Sqflite.firstIntValue(await db.rawQuery(
      "select count(1) from $table"));
  return count;
}

// 保存到收藏列表
Future saveFavorite(Map<String, dynamic> data) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.insert(table, data);
}

// 从收藏表中移除
Future removeFavorite({sid, source}) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db
      .delete(table, where: "sid=? and source = ?", whereArgs: [sid, source]);
}

// 从收藏表中移除
Future removeFavoriteByFid({fid}) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.delete(table, where: "fid=?", whereArgs: [fid]);
}

// 检查当前歌曲是否存在
Future checkFavoriteExist({sid, source}) async {
  Database db = await DbUtil.getInstance().getDb();
  int count = Sqflite.firstIntValue(await db.rawQuery(
      "select count(1) from $table where sid = $sid and source = '$source'"));
  return count >= 1 ? true : false;
}
