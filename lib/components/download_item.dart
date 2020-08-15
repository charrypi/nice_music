import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/model/download_file.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DownLoadItem extends StatefulWidget {
  final int index;
  final DownloadFile file;

  DownLoadItem({this.index, this.file});

  @override
  _DownLoadItemState createState() => _DownLoadItemState();
}

class _DownLoadItemState extends State<DownLoadItem> {
  @override
  Widget build(BuildContext context) {
    double percent = 0;
    if (widget.file.total != null && widget.file.total != -1) {
      percent = widget.file.recieved / widget.file.total;
    }
    // 下载完成移除列表
    if (percent == 1) {
      //以防止一边build一边删除造成异常
//      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//        Provider.of<DownLoadingFilesNotifier>(context, listen: false)
//            .removeDownLoadingFile(widget.file);
//      });
    }
    return Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 3),
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              alignment: Alignment.center,
              child: _buildStatusLeading(),
            ),
            Expanded(
                child: Stack(
              children: <Widget>[
                LinearPercentIndicator(
                  padding: EdgeInsets.all(0),
                  percent: percent,
                  lineHeight: 50,
                  linearStrokeCap: LinearStrokeCap.butt,
                  backgroundColor: Colors.transparent,
                  animateFromLastPercent: true,
                  progressColor: Colors.lightGreenAccent.withOpacity(0.4),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(widget.file.fileName),
                    )),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: widget.file.total != null
                          ? Text((widget.file.total / 1024 / 1024)
                                  .toStringAsFixed(2) +
                              'M')
                          : Text('--M'),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text((percent * 100).toStringAsFixed(0) + '%'),
                    )
                  ],
                )
              ],
            )),
          ],
        ));
  }

  _buildStatusLeading() {
    switch (widget.file.status) {
      case DownloadStatus.LOADING:
        return SvgPicture.asset('icons/internal.svg', width: 25);
      case DownloadStatus.COMPLETED:
        return SvgPicture.asset('icons/ok.svg', width: 25);
      case DownloadStatus.ERROR:
        return SvgPicture.asset('icons/high_priority.svg', width: 25);
    }
  }
}
