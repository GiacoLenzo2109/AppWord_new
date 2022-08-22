import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:material_dialogs/material_dialogs.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemesUtil.isAndroid(context)
        ? Lottie.asset(
            "assets/animations/loading.json",
            height: ScreenUtil.getSize(context).height / 2.5,
            repeat: true,
          )
        : const CupertinoActivityIndicator();
  }
}
