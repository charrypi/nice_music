import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nicemusic/common/playfunc.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/store/play_list_notifier.dart';
import 'package:provider/provider.dart';

/// 播放页面弹出的播放列表
class PlayListModal extends StatefulWidget {
  @override
  _PlayListModalState createState() => _PlayListModalState();
}

class _PlayListModalState extends State<PlayListModal> {
  @override
  Widget build(BuildContext context) {
    List<PlayListModel> datas = Provider.of<PlayListNotifier>(context).playList;
    return Material(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: <Widget>[
              Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(5),
          child: Text(
            "播放列表(${datas.length})",
            style: TextStyle(fontSize: 18),
          ),
        ),
      Divider(),
              datas.length == 0
                  ? Align(
                      child: Text('列表空空如也~',style: TextStyle(fontSize: 15),),
                    )
                  : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      PlayListModel model = datas[index];
                      return ListTile(
                        leading: Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        title: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: model.sname,
                                      style: TextStyle(fontSize: 16)),
                                  TextSpan(
                                      text: '\t\t\t${model.source}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue))
                                ])),
                        subtitle: Text(_getSubTitle(model)),
                        trailing: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => _remove(model)),
                        onTap: () => _play(model),
                      );
                    })
              )
            ],
          ),
        ));
  }

  _getSubTitle(PlayListModel model) {
    String subTitle = model.artists;
    if (model.albumName != null && model.albumName.isNotEmpty) {
      subTitle += "－" + model.albumName;
    }
    return subTitle;
  }

  _remove(PlayListModel model) {
    Provider.of<PlayListNotifier>(context, listen: false).remove(model);
  }

  _play(PlayListModel model) {
    playInPlayList(model);
  }
}
