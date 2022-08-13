import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String text;
  final double? height;
  final double? padding;
  final Icon? icon;
  final Color? textColor;
  final Function()? onPressed;

  const ButtonWidget(
      {super.key,
      this.height,
      this.onPressed,
      this.backgroundColor,
      required this.text,
      this.padding,
      this.icon,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? ElevatedButton(
            onPressed: onPressed ?? () {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(1.0),
              backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? ThemesUtil.getPrimaryColor(context),
              ),
              minimumSize: MaterialStateProperty.all(
                  Size(ScreenUtil.getSize(context).width, height ?? 50)),
            ),
            child: icon != null
                ? Row(
                    children: [
                      icon ?? const Text(""),
                      Text(
                        text,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.white),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white),
                  ),
          )
        : CupertinoButton(
            padding: EdgeInsets.all(padding ?? 0),
            color: backgroundColor ?? ThemesUtil.getPrimaryColor(context),
            onPressed: onPressed ?? () {},
            child: icon != null
                ? Row(
                    children: [
                      icon!,
                      Text(
                        text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: textColor ?? Colors.white),
                      )
                    ],
                  )
                : Text(
                    text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: textColor ?? Colors.white),
                  ),
          );
  }
}
