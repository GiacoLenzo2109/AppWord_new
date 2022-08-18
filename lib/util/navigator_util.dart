import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigatorUtil {
  static navigateTo(
      {required BuildContext context,
      required Widget Function(BuildContext) builder}) {
    Navigator.of(context).push(
      Theme.of(context).platform == TargetPlatform.android
          ? MaterialPageRoute(builder: builder)
          : CupertinoPageRoute(builder: builder),
    );
  }
}
