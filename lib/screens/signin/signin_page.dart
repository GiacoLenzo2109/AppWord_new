import 'package:app_word/screens/signin/login_page.dart';
import 'package:app_word/screens/signin/register_page.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      scrollable: false,
      isFullScreen: true,
      backgroundColor: ThemesUtil.getBackgroundColor(context),
      titleColor: ThemesUtil.getContrastingColor(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                "assets/animations/signin_animation.json",
                height: ScreenUtil.getSize(context).height / 2.8,
                repeat: true,
              ),
              // Image.asset(
              //   "assets/App_Logo.png",
              //   width: ScreenUtil.getSize(context).width / 2,
              // ),
            ],
          ),
          StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 25,
            children: [
              ButtonWidget(
                text: "Login",
                padding: 20,
                onPressed: () => NavigatorUtil.navigateTo(
                  context: context,
                  builder: (context) => const LoginPage(),
                ),
              ),
              ButtonWidget(
                text: "Registrati",
                padding: 20,
                onPressed: () => NavigatorUtil.navigateTo(
                  context: context,
                  builder: (context) => const RegisterPage(),
                ),
                backgroundColor: CupertinoColors.systemRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
