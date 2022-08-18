import 'package:app_word/util/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ContaienrWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final double? padding;
  final double? margin;

  const ContaienrWidget(
      {Key? key,
      this.backgroundColor,
      this.padding,
      this.margin,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin ?? 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor ??
            (Theme.of(context).platform == TargetPlatform.android
                ? Theme.of(context).backgroundColor
                : CupertinoThemes.backgroundColor(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 25),
        child: child,
      ),
    );
  }
}
