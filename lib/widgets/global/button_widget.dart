import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final Color? backgroundColor;
  final String text;
  final double? height;
  final double? padding;
  final Widget? icon;
  final Icon? suffixIcon;
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
      this.suffixIcon,
      this.textColor});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? ElevatedButton(
            onPressed: widget.onPressed ?? () {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                widget.backgroundColor ?? ThemesUtil.getPrimaryColor(context),
              ),
              minimumSize: MaterialStateProperty.all(
                  Size(ScreenUtil.getSize(context).width, widget.height ?? 50)),
            ),
            child: widget.icon != null
                ? Stack(
                    children: [
                      widget.icon ?? const Text(""),
                      Center(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        child: Text(
                          widget.text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: widget.textColor ?? Colors.white),
                        ),
                      ),
                    ],
                  )
                : Text(
                    widget.text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: widget.textColor ?? Colors.white),
                  ),
          )
        : CupertinoButton(
            padding: EdgeInsets.all(widget.padding ?? 0),
            color:
                widget.backgroundColor ?? ThemesUtil.getPrimaryColor(context),
            onPressed: widget.onPressed ?? () {},
            child: widget.icon != null
                ? Row(
                    mainAxisAlignment: widget.suffixIcon != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            widget.icon!,
                            const SizedBox(width: 15),
                            Text(
                              widget.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: widget.textColor ?? Colors.white),
                            ),
                          ],
                        ),
                      ),
                      if (widget.suffixIcon != null) widget.suffixIcon!,
                    ],
                  )
                : Text(
                    widget.text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: widget.textColor ?? Colors.white),
                  ),
          );
  }
}
