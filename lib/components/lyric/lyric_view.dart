import 'package:flutter/material.dart';
import 'package:nicemusic/components/custom_scroll_behavior.dart';
import 'package:nicemusic/components/lyric/lyric_entry.dart';
import 'package:nicemusic/store/player_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricView extends StatefulWidget {
  final List<LyricEntry> lyrics;
  final TextStyle selectedTextStyle;
  final TextStyle unSelectedTextStyle;

  LyricView({this.lyrics, this.selectedTextStyle, this.unSelectedTextStyle});

  @override
  _LyricViewState createState() => _LyricViewState();
}

class _LyricViewState extends State<LyricView> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Duration position = Provider.of<PlayerStateNotifier>(context).position;
    int index = _computeIndex(position);
    this._index = index;
    // 滑动到指定索引位置
    _scroll(index);
  }

  _scroll(index) {
    // 确保滑动时候controller已经和view绑定
    if (!itemScrollController.isAttached) {
      Future.delayed(Duration(milliseconds: 50), () {
        _scroll(index);
      });
    } else {
      itemScrollController.scrollTo(
          index: index,
          duration: Duration(milliseconds: 800),
          curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyrics == null || widget.lyrics.length == 0) {
      return Text('暂无歌词~', style: TextStyle(color: Colors.white));
    }
    return ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemCount: widget.lyrics.length,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) {
              return Container(
//            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                margin:
                    EdgeInsets.only(top: 5, bottom: 5, left: 100, right: 100),
                alignment: Alignment.center,
                child: Text(
                  widget.lyrics[index].content,
                  style: _index == index
                      ? widget.selectedTextStyle
                      : widget.unSelectedTextStyle,
                  textAlign: TextAlign.center,
                ),
              );
            }));
  }

  // 计算当前时间的歌词的位置索引
  int _computeIndex(Duration position) {
    int i = 0;
//    if (widget.lyrics[0].time == -1) {
//      return i;
//    }
    for (i = 0; i < widget.lyrics.length - 1; i++) {
      LyricEntry entry = widget.lyrics[i];
      LyricEntry nextEntry = widget.lyrics[i + 1];
      if (entry.time <= position.inMilliseconds &&
          nextEntry.time > position.inMilliseconds) {
        break;
      }
    }
    return i;
  }
}
