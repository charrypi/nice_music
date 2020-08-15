// 当前下载文件
class DownloadFile {
  // 唯一标识
  String id;

  // 总大小
  int total = -1;

  // 已接收
  int recieved = 0;

  // 文件名称
  String fileName;

  // 下载状态
  DownloadStatus status;

  DownloadFile(
      {this.id, this.total, this.recieved, this.fileName, this.status});
}

enum DownloadStatus { LOADING, ERROR, COMPLETED }
