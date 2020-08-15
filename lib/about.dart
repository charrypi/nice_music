import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('关于播放器', style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Hero(
                    tag: 'logo',
                    child: SvgPicture.asset('icons/nice_music_logo.svg'))
              ],
            ),
            Column(
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                      TextSpan(
                          text: '\t\t\t\t\t\t\t\t花生音乐是一款集合多家音乐平台于一身的App,'
                              ' 她的构思源于作者对音乐的喜爱，其次一些音乐因为版权原因，'
                              '有时候不得不去下载多个音乐平台的APP软件才能听到。\n\n'),
                      TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          text:
                              '\t\t\t\t\t\t\t\t花生音乐的数据全部来源于各官方音乐平台的服务器，且不拥有对任何音乐、图片、名称的版权。'
                              '本APP里使用的静态资源包括但不限于字体、图片等均来自互联网，如侵权可联系作者删除。花生音乐源代码开源，开发她的'
                              '初衷是用于技术研究和学习，切勿用于商业用途。\n\n'),
                      TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          text:
                              '\t\t\t\t\t\t\t\t由于使用本软件产生的包括由于本协议或由于使用或无法使用本软件而引起的任何性质的任何'
                              '直接、间接、特殊、偶然或结果性损害（包括但不限于因商誉损失、停工、计算机故障或'
                              '故障引起的损害赔偿，或任何及所有其他商业损害或损失）由使用者负责。\n\n'),
                      TextSpan(
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          text: '\t\t\t\t\t\t\t\t打开使用该APP即代表使用者认同及接受以上协议。')
                    ]))
              ],
            )
          ]),
        ));
  }
}
