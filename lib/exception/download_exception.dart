class DownLoadException implements Exception {
  static final String msg = '下载文件异常';

  @override
  String toString() {
    return msg;
  }
}
