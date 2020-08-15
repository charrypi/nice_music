import 'package:sqflite/sqflite.dart';
import 'package:nicemusic/util/db_util.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/model/playlist_query.dart';

const String table = "play_list";

// 分页查询列表
Future<PlayListQuery> queryPlayList(PlayListQuery query) async {
  Database db = await DbUtil.getInstance().getDb();
  List<Map<String, dynamic>> result = await db.query(table,
      limit: query.rows == -1 ? null : query.rows,
      offset: query.rows == -1 ? null : (query.page - 1) * query.rows,
      orderBy: 'pid desc');
  List<PlayListModel> playlist = List();
  result.forEach((r) {
    playlist.add(PlayListModel.fromJson(r));
  });
  int total = await getPlayListTotal(query);
  query.result = playlist;
  query.total = total;
  return query;
}

// 获取列表总个数
Future<int> getPlayListTotal(PlayListQuery query) async {
  Database db = await DbUtil.getInstance().getDb();
  int count =
      Sqflite.firstIntValue(await db.rawQuery("select count(1) from $table"));
  return count;
}

// 保存到播放列表
Future saveToPlayList(Map<String, dynamic> data) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.transaction((txn) async {
    return await txn.insert(table, data);
  });
}

// 从播放列表中移除
Future removePlayListByPid({pid}) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.delete(table, where: 'pid=?', whereArgs: [pid]);
}

// 检查当前歌曲是否存在列表中
Future checkPlayListExist({sid, source}) async {
  Database db = await DbUtil.getInstance().getDb();
  int pid = Sqflite.firstIntValue(await db.rawQuery(
      "select pid from $table where sid = $sid and source = '$source'"));
  return pid;
}

// 清空列表
Future emptyPlayList() async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.rawQuery('delete from $table');
}
