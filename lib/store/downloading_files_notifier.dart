import 'package:flutter/foundation.dart';
import 'package:nicemusic/model/download_file.dart';

/// 下载列表 Provider
class DownLoadingFilesNotifier with ChangeNotifier {
  List<DownloadFile> _files = List<DownloadFile>();

  List<DownloadFile> get files => this._files;

  // 更新下载列表
  updateDownloadingList(List<DownloadFile> fs) {
    this._files = fs;
    notifyListeners();
  }

  // 列表新增
  addDownloadingFile(DownloadFile file) {
    this._files.add(file);
    notifyListeners();
  }

  // 移除已经特定状态的下载任务
  removeDownloadFilesByStatus(DownloadStatus status) {
    this._files.removeWhere((f) => f.status == status);
    notifyListeners();
  }

  // 列表删除
  removeDownLoadingFile(DownloadFile file) {
    this._files.removeWhere((f) => f.id == file.id);
    notifyListeners();
  }

  // 更新进度
  updateDownloadingFile(DownloadFile file) {
    this._files.forEach((f) {
      if (f.id == file.id) {
        f.recieved = file.recieved;
        f.total = file.total;
        f.status = file.status;
        notifyListeners();
      }
    });
  }
}
