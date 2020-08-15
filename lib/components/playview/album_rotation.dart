import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nicemusic/store/player_state_notifier.dart';
import 'package:provider/provider.dart';

// 唱片图旋转组件
class AlbumRotation extends StatefulWidget {
  final String albumPic;

  AlbumRotation({this.albumPic});

  @override
  _AlbumRotationState createState() => _AlbumRotationState();
}

class _AlbumRotationState extends State<AlbumRotation>
    with SingleTickerProviderStateMixin {
  AnimationController _albumAnimationCtl;

  AudioPlayerState audioPlayerState;

  @override
  void initState() {
    super.initState();
    _initAlbumAnimationCtrl();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    audioPlayerState = Provider.of<PlayerStateNotifier>(context).audioPlayerState;
    if (audioPlayerState == AudioPlayerState.PLAYING) {
      _albumAnimationCtl.repeat();
    }
    if(audioPlayerState == AudioPlayerState.PAUSED){
      // 暂停
      _albumAnimationCtl.stop();
    }
    if(audioPlayerState == AudioPlayerState.COMPLETED){
      //停止
      _albumAnimationCtl.stop();
    }
  }

  @override
  void dispose() {
    _albumAnimationCtl.dispose();
    super.dispose();
  }

  _initAlbumAnimationCtrl() {
    _albumAnimationCtl =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    _albumAnimationCtl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (audioPlayerState == AudioPlayerState.PLAYING) {
          _albumAnimationCtl.repeat();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CachedNetworkImage _albumPic = CachedNetworkImage(imageUrl: '${widget.albumPic}',
        imageBuilder: (context, image) => CircleAvatar(
          backgroundImage: image
        ),
        placeholder:(context,url)=> const CircleAvatar(
          backgroundImage: AssetImage('icons/default_album.jpg'),
        )
    );
    return RotationTransition(
      turns: _albumAnimationCtl,
      child: _albumPic,
    );
  }
}
