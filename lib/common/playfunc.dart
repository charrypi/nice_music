import 'package:flutter/material.dart';
import 'package:nicemusic/api/platform_api.dart';
import 'package:nicemusic/common/navkey.dart';
import 'package:nicemusic/constants/music_platform.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/event/player_state_event.dart';
import 'package:nicemusic/model/playlist_model.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';

playInPlayList(PlayListModel model) async {
  BuildContext context = NavKey.navKey.currentContext;
  try {
    eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.CONNECTING));
    PlatformApi api = MusicPlatforms.get(model.source).api;
    final query = {'id': model.sid, 'mid': model.mid, 'albumId': model.albumId};
    PlayerProperties playerProperties = PlayerProperties();
    playerProperties.isLocal = false;
    playerProperties.sid = model.sid;
    playerProperties.source = model.source;
    playerProperties.mid = model.mid;
    playerProperties.songName = model.sname;
    playerProperties.albumId = model.albumId;
    playerProperties.albumName = model.albumName;
    playerProperties.artists = model.artists;
    String playUrl = await api.getPlayUrl(query);
    playerProperties.url = playUrl;
    String albumPic = await api.getAlbumPic(query);
    playerProperties.albumPicUrl = albumPic;
    String lyric = await api.getLyric(query);
    playerProperties.lyric = lyric;

    // 触发播放
    eventBus.fire(PlayerEvent(
        cmd: PlayerCmd.PLAY,
        pid: model.pid,
        playerProperties: playerProperties));
  } catch (e) {
    eventBus.fire(PlayerStateEvent(state: PlayerStateEnum.ERROR));
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          '获取歌曲信息失败',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red));
  }
}
