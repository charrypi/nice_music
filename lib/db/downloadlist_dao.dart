import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/model/downloadlist_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nicemusic/util/db_util.dart';

const String table = "download_list";

// 查询列表
Future<DownloadListQuery> queryDownloadList(DownloadListQuery query) async {
  Database db = await DbUtil.getInstance().getDb();
  List<Map<String, dynamic>> result = await db.query(table,
      limit: query.rows,
      offset: (query.page - 1) * query.rows,
      orderBy: 'did desc');
  List<DownloadListModel> downloads = List();
  result.forEach((r) {
    downloads.add(DownloadListModel.fromJson(r));
  });
  int total = await getDownloadListTotal(query);
  query.result = downloads;
  query.total = total;
  return query;
}

// 获取总个数
Future<int> getDownloadListTotal(DownloadListQuery query) async {
  Database db = await DbUtil.getInstance().getDb();
  int count =
      Sqflite.firstIntValue(await db.rawQuery("select count(1) from $table"));
  return count;
}

Future<int> addDownloadList(DownloadListModel model) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.transaction((txn) {
    return txn.insert(table, model.toJson());
  });
}

Future<int> removeDownloadList(DownloadListModel model) async {
  Database db = await DbUtil.getInstance().getDb();
  return await db.transaction((txn) {
    return txn.delete(table, where: 'did=?', whereArgs: [model.did]);
  });
}
