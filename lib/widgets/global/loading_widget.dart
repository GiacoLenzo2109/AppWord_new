import 'dart:ui';

import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_dialogs/material_dialogs.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: ThemesUtil.isAndroid(context)
            ? Lottie.asset(
                "assets/animations/loading.json",
                height: ScreenUtil.getSize(context).height / 2.5,
                repeat: true,
              )
            : CupertinoActivityIndicator(
                color: ThemesUtil.getContrastingColor(context),
                radius: 14.0,
              ),
      ),
    );
  }
}
