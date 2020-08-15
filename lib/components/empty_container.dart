import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 空内容提示组件
class EmptyContainer extends StatefulWidget {
  final String assetName;
  final String tips;

  EmptyContainer({this.assetName, this.tips});

  @override
  _EmptyContainerState createState() => _EmptyContainerState();
}

class _EmptyContainerState extends State<EmptyContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(widget.assetName,width: 100),
          Container(height: 20),
          Text(widget.tips,style: TextStyle(fontSize: 15))
        ],
      )
    );
  }
}
