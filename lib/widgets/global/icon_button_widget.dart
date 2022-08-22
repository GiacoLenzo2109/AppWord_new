import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class IconButtonWidget extends StatefulWidget {
  final Function() onPressed;
  final Widget icon;

  const IconButtonWidget(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ThemesUtil.isAndroid(context)
        ? IconButton(onPressed: widget.onPressed, icon: widget.icon)
        : CupertinoButton(
            onPressed: widget.onPressed,
            padding: const EdgeInsets.all(0),
            child: widget.icon,
          );
  }
}
