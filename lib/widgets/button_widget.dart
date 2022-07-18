import 'package:app_word/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final String text;

  const ButtonWidget(
      {super.key, required this.backgroundColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? ElevatedButton(
            onPressed: () => {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1.0),
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              minimumSize: MaterialStateProperty.all(
                  Size(ScreenUtil.getSize(context).width, 50)),
            ),
            child: Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white),
            ),
          )
        : CupertinoButton(
            color: backgroundColor,
            child: Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white),
            ),
            onPressed: () {},
          );
  }
}
