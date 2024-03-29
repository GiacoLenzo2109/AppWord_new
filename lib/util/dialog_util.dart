import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DialogUtil {
  static openDialog(
      {required BuildContext context,
      required Widget Function(BuildContext) builder}) {
    Theme.of(context).platform == TargetPlatform.android
        ? showDialog(context: context, builder: builder)
        : showCupertinoDialog(context: context, builder: builder);
  }

  static showModalBottomSheet(
      {required BuildContext context,
      required Widget Function(BuildContext) builder}) {
    Theme.of(context).platform == TargetPlatform.android
        ? showMaterialModalBottomSheet(
            context: NavigationService.navigatorKey.currentContext!,
            builder: builder,
          )
        : CupertinoScaffold.showCupertinoModalBottomSheet(
            useRootNavigator: true,
            context: context,
            builder: builder,
          );
  }

  static showModalPopupSheet(
      {required BuildContext context,
      required Widget Function(BuildContext) builder}) {
    Theme.of(context).platform == TargetPlatform.android
        ? showDialog(
            context: context,
            builder: builder,
          )
        : showCupertinoModalPopup(
            useRootNavigator: true,
            context: context,
            builder: builder,
          );
  }
}
