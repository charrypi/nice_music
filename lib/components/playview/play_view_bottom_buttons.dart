import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nicemusic/components/playview/playlist_modal.dart';
import 'package:nicemusic/store/player_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:nicemusic/store/playmode_notifier.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';
import 'package:nicemusic/store/player_properties_notifier.dart';

// 歌曲详情页底部按钮组件
class PlayViewBottomButtons extends StatefulWidget {
  final PlayerProperties playerProperties;

  PlayViewBottomButtons({this.playerProperties});

  @override
  _PlayViewBottomButtonsState createState() => _PlayViewBottomButtonsState();
}

class _PlayViewBottomButtonsState extends State<PlayViewBottomButtons> {
  AudioPlayerState audioPlayerState;

  @override
  Widget build(BuildContext context) {
    bool _isPlaying =
        Provider.of<PlayerStateNotifier>(context).audioPlayerState ==
            AudioPlayerState.PLAYING;

    bool _isPause =
        Provider.of<PlayerStateNotifier>(context).audioPlayerState ==
            AudioPlayerState.PAUSED;

    return Container(
        margin: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: _buildPlayMode(),
                  ),
                  onTap: _changePlayMode),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: SvgPicture.asset("icons/skip_to_start.svg", width: 40),
                  onTap: widget.playerProperties.url == null
                      ? null
                      : () {
                          eventBus.fire(PlayerEvent(
                              cmd: PlayerCmd.FORWARD,
                              playerProperties: widget.playerProperties));
                        }),
            ),
            Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: _isPlaying
                        ? SvgPicture.asset(
                            "icons/circled_play.svg",
                            width: 60,
                          )
                        : SvgPicture.asset(
                            "icons/pause_button.svg",
                            width: 60,
                          ),
                    onTap: widget.playerProperties.url == null
                        ? null
                        : () {
                            if (_isPlaying) {
                              eventBus.fire(PlayerEvent(
                                  cmd: PlayerCmd.PAUSE,
                                  playerProperties: widget.playerProperties));
                            } else if (_isPause) {
                              eventBus.fire(PlayerEvent(
                                  cmd: PlayerCmd.PLAY,
                                  playerProperties: widget.playerProperties));
                            }
                          })),
            Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: SvgPicture.asset("icons/skip_to_end.svg", width: 40),
                  onTap: widget.playerProperties.url == null
                      ? null
                      : () {
                          eventBus.fire(PlayerEvent(
                              cmd: PlayerCmd.NEXT,
                              playerProperties: widget.playerProperties));
                        }),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: SvgPicture.asset("icons/menu.svg", width: 35),
                onTap: () {
                  showModalBottomSheet(
                      barrierColor: Colors.black12.withOpacity(0.5),
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (builder) {
                        return PlayListModal();
                      });
                },
              ),
            )
          ],
        ));
  }

  _buildPlayMode() {
    PlayMode playMode = Provider.of<PlayModeNotifier>(context).playMode;
    switch (playMode) {
      case PlayMode.SINGLE_LOOP:
        return SvgPicture.asset('icons/repeat_one.svg', width: 40);
      case PlayMode.LIST_LOOP:
        return SvgPicture.asset('icons/repeat.svg', width: 40);
      case PlayMode.RANDOM_LOOP:
        return SvgPicture.asset('icons/shuffle.svg', width: 40);
    }
  }

  void _changePlayMode() {
    PlayMode playMode =
        Provider.of<PlayModeNotifier>(context, listen: false).playMode;
    List<PlayMode> modes = PlayMode.values;
    int index = modes.indexOf(playMode);
    if (index == modes.length - 1) {
      index = 0;
    } else {
      index++;
    }
    PlayMode changedMode = modes[index];
    String toastText = "";
    switch (changedMode) {
      case PlayMode.SINGLE_LOOP:
        toastText = '单曲循环';
        break;
      case PlayMode.LIST_LOOP:
        toastText = '列表循环';
        break;
      case PlayMode.RANDOM_LOOP:
        toastText = '随机循环';
        break;
    }
    BotToast.showText(text: toastText);
    Provider.of<PlayModeNotifier>(context, listen: false)
        .changePlayMode(changedMode);
  }
}
