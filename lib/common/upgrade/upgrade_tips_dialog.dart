import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgradeModal extends StatefulWidget {
  final List<String> updateMsgs;
  final String downloadUrl;
  final Function cancelFunc;

  UpgradeModal(this.updateMsgs, this.downloadUrl, this.cancelFunc);

  @override
  _UpgradeModalState createState() => _UpgradeModalState();
}

class _UpgradeModalState extends State<UpgradeModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text('有更新可用！'),
      content: RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.black), children: _buildMsg())),
      actions: <Widget>[
        FlatButton(
            onPressed: () => widget.cancelFunc(),
            child: Text(
              '取消',
              style: TextStyle(color: Colors.redAccent),
            )),
        FlatButton(
          child: Text('前往下载'),
          onPressed: () => _goToDownload(),
        )
      ],
    );
    ;
  }

  _buildMsg() {
    List<TextSpan> spans = [];
    widget.updateMsgs.forEach((msg) {
      spans.add(TextSpan(text: "$msg\n"));
    });
    return spans;
  }

  _goToDownload() async {
    {
      widget.cancelFunc();
      if (await canLaunch(widget.downloadUrl)) {
        launch(widget.downloadUrl);
      }
//            BotToast.showAnimationWidget(
//                toastBuilder: (cancel) {
//                  return UpgradeProgressDialog(widget.downloadUrl,cancel);
//                },
//                animationDuration: Duration(seconds: 1));
    }
  }
}
