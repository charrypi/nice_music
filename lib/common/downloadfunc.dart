import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:nicemusic/common/navkey.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/event/download_completed_event.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/model/download_file.dart';
import 'package:nicemusic/model/downloadlist_model.dart';
import 'package:nicemusic/store/downloading_files_notifier.dart';

download(DownloadListModel downloadModel) async{
  BuildContext context = NavKey.navKey.currentContext;
  String downloadId = downloadModel.source + "_" + downloadModel.sid.toString();
  String fileName = downloadModel.artists + '-' + downloadModel.sname;
  List<DownloadFile> downloadingFiles =
      Provider.of<DownLoadingFilesNotifier>(context, listen: false).files;
  int index = downloadingFiles.indexWhere((f) => f.id == downloadId);
  if (index > -1) {
    BotToast.showNotification(
        duration: Duration(seconds: 3),
        title: (_) => Text('提示'),
        subtitle: (_) => Text('$fileName 已在下载列表中'),
        leading: (_) => SvgPicture.asset('icons/info_squared.svg'));
    return;
  }
  PlatformApi api = MusicPlatforms.get(downloadModel.source).api;
  DownloadFile downloadFile = DownloadFile(
      id: downloadId, fileName: fileName, status: DownloadStatus.LOADING);
  Provider.of<DownLoadingFilesNotifier>(context, listen: false)
      .addDownloadingFile(downloadFile);
  try {
    BotToast.showNotification(
        duration: Duration(seconds: 3),
        title: (_) => Text('任务提示'),
        subtitle: (_) => Text('${downloadModel.sname}已加入到下载列表'),
        leading: (_) => SvgPicture.asset('icons/internal.svg'));
   await api.downloadFile(downloadModel, (recieved, total) {
      downloadFile.total = total;
      downloadFile.recieved = recieved;
      if (total == recieved) {
        downloadFile.status = DownloadStatus.COMPLETED;
        // 通知下载完成列表更新
        eventBus.fire(DownLoadCompletedEvent());
      }
      Provider.of<DownLoadingFilesNotifier>(context, listen: false)
          .updateDownloadingFile(downloadFile);
    });
  } catch (e) {
    BotToast.showText(text: '${downloadModel.sname}下载失败');
    downloadFile.status = DownloadStatus.ERROR;
    Provider.of<DownLoadingFilesNotifier>(context, listen: false)
        .updateDownloadingFile(downloadFile);
  }
}
