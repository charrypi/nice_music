import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//数据库工具类，单例
class DbUtil {
  DbUtil._();

  static DbUtil _instance;

  static DbUtil getInstance() {
    if (_instance == null) {
      _instance = DbUtil._();
    }
    return _instance;
  }

  Future<Database> _db;

  // 固化数据库名称和版本号
  static const String dbName = 'nice_music.db';
  static const int dbVersion = 1;

  ///创建收藏表
  ///字段 fid sid mid sname artists albumId albumName albumPic source
  ///说明 主键 歌曲主键 歌曲唯一标识 歌曲名称 作者列表 专辑主键 专辑名称 专辑图片 来源
  static const String _createFavoriteTable =
      "CREATE TABLE song_favorite (fid INTEGER PRIMARY KEY,sid INT, mid TEXT,sname TEXT, artists TEXT, albumId TEXT, albumName TEXT, albumPic TEXT, source TEXT)";

  ///创建播放列表
  ///字段 pid sid mid sname artists albumId albumName albumPic source
  ///说明 主键 歌曲主键 歌曲唯一标识 歌曲名称 作者列表 专辑主键 专辑名称 专辑图片 来源
  static const String _createPlayListTable =
      "CREATE TABLE play_list (pid INTEGER PRIMARY KEY,sid INT, mid TEXT, sname TEXT, artists TEXT, albumId TEXT, albumName TEXT, albumPic TEXT, source TEXT)";

  ///创建下载列表
  ///字段 pid sid mid sname artists albumId albumName albumPic source fileSize localPath
  ///说明 主键 歌曲主键 歌曲唯一标识 歌曲名称 作者列表 专辑主键 专辑名称 专辑图片 来源 文件大小 本地存放路径
  static const String _createDownloadListTable =
      "CREATE TABLE download_list(did INTEGER PRIMARY KEY,sid INT, mid TEXT, sname TEXT, artists TEXT, albumId TEXT, albumName TEXT, albumPic TEXT, source TEXT, fileSize int, localPath TEXT)";

  // 获取数据库
  Future<Database> getDb() async {
    final dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, dbName);
    if (_db == null) {
      return await openDatabase(path, version: dbVersion,
          onCreate: (Database db, int version) async {
        print('开始初始化数据表');
        // 首次创建表
        await db.execute(_createFavoriteTable);
        await db.execute(_createPlayListTable);
        await db.execute(_createDownloadListTable);
      }, onOpen: (Database db) {
        print('数据库已连接.');
      });
    } else {
      return _db;
    }
  }
}
