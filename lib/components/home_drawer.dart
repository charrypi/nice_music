import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nicemusic/about.dart';
import 'package:nicemusic/settings.dart';

/// 侧边栏菜单面板
class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('icons/drawer_bg.png'))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: ClipOval(
                        child: Hero(
                            tag: 'logo',
                            child:
                                SvgPicture.asset('icons/nice_music_logo.svg'))),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return AboutPage();
                      }));
                    }),
              ),
              Text('      花生音乐，听不一样的声音！',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('设置'),
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return SettingsPage();
            }));
          },
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.headset),
            title: Text('关于'),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                return AboutPage();
              }));
            }),
        Divider(),
        ListTile(
            leading: SvgPicture.asset(
              'icons/github.svg',
              width: 27,
            ),
            title: Text('GitHub'),
            onTap: () async {
              const url = "https://github.com/pizhaojun";
              if (await canLaunch(url)) {
                launch(url);
              }
            }),
        Divider(),
      ],
    );
  }
}
