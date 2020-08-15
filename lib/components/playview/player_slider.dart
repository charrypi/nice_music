import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nicemusic/store/player_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:nicemusic/event/event_bus.dart';
import 'package:nicemusic/event/player_event.dart';


// 播放进度条
class PlayerSlider extends StatefulWidget {
  @override
  _PlayerSliderState createState() => _PlayerSliderState();
}

class _PlayerSliderState extends State<PlayerSlider> {

  @override
  Widget build(BuildContext context) {
    Duration _position = Provider
        .of<PlayerStateNotifier>(context)
        .position;
    Duration _duration = Provider
        .of<PlayerStateNotifier>(context)
        .duration;
    String _positionText =
        _position
            ?.toString()
            ?.split('.')
            ?.first ?? '0:00:00';
    String _durationText =
        _duration
            ?.toString()
            ?.split('.')
            ?.first ?? '0:00:00';

    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              _positionText,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                inactiveTrackColor: Colors.white,
                activeTrackColor: Colors.lightBlueAccent,
                thumbColor: Colors.white,
                trackHeight: 1,
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 5.0,
                    disabledThumbRadius: 8.0)),
            child: Slider(
                value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds <
                        _duration.inMilliseconds)
                    ? _position.inMilliseconds /
                    _duration.inMilliseconds
                    : 0.0,
                onChanged: (v) {
                  final position = v * _duration.inMilliseconds;
                  eventBus.fire(PlayerEvent(
                      cmd: PlayerCmd.SEEK,
                      duration: Duration(
                          milliseconds: position.round())));
                }),
          ),
          Container(
            child: Text(
              _durationText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]);
  }
}
