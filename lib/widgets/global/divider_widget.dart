import 'package:app_word/util/themes.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .15,
      margin: EdgeInsets.only(right: ThemesUtil.isAndroid(context) ? 10 : 0),
      color: Colors.grey,
    );
  }
}
