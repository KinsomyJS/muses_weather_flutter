import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    new TextField(
      maxLines: 1,
      style: TextStyle(fontSize: 30.0, color: Colors.white), //输入文本的样式
      decoration: InputDecoration(
        hintText: '输入城市',
        prefixIcon: new Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
