import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class IconButtonWidget extends StatefulWidget {
  final Function() onPressed;
  final Widget icon;
  final Color? backgroundColor;

  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ThemesUtil.isAndroid(context)
        ? ElevatedButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.all(0),
              ),
              splashFactory: NoSplash.splashFactory,
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                widget.backgroundColor ?? Colors.transparent,
              ),
            ),
            child: widget.icon,
            //label: const Text(""),
          )
        : CupertinoButton(
            onPressed: widget.onPressed,
            padding: const EdgeInsets.all(0),
            color: widget.backgroundColor ?? Colors.transparent,
            child: widget.icon,
          );
  }
}
