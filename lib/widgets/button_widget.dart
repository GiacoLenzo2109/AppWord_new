import 'package:app_word/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final double? height;
  final Function()? onPressed;

  const ButtonWidget(
      {super.key,
      this.height,
      this.onPressed,
      required this.backgroundColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? ElevatedButton(
            onPressed: onPressed ?? () {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1.0),
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              minimumSize: MaterialStateProperty.all(
                  Size(ScreenUtil.getSize(context).width, height ?? 50)),
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
            padding: EdgeInsets.all(0),
            color: backgroundColor,
            onPressed: onPressed ?? () {},
            child: Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white),
            ),
          );
  }
}
