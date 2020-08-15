import 'package:flutter/material.dart';

// 加载更多组件
class ListMore extends StatefulWidget {
  final bool isEnd;

  ListMore({this.isEnd});

  @override
  _ListMoreState createState() => _ListMoreState();
}

class _ListMoreState extends State<ListMore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.isEnd
                ? [Text('这是我的底线~',style: TextStyle(fontSize: 12),)]
                : [
                    SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    Container(width: 15),
                    Text('正在努力加载中…', style: TextStyle(fontSize: 12))
                  ]),
      ),
    );
  }
}
