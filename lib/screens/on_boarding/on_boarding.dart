import 'package:app_word/screens/on_boarding/on_boarding_pages.dart';
import 'package:app_word/screens/signin/signin_page.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      scrollable: false,
      padding: 0,
      body: IntroductionScreen(
        pages: OnBoardingPages.build(context),
        onDone: () => NavigatorUtil.navigateTo(
          context: context,
          builder: (context) => const SignInPage(),
        ),
        globalBackgroundColor: ThemesUtil.getBackgroundColor(context),
        showBackButton: false,
        showSkipButton: true,
        showDoneButton: true,
        //controlsMargin: const EdgeInsets.all(0),
        //controlsPadding: const EdgeInsets.symmetric(vertical: 100),
        skip: Text(
          "Salta",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: ThemesUtil.isAndroid(context)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        skipStyle: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        next: Text("Avanti",
            style: TextStyle(
              fontWeight: ThemesUtil.isAndroid(context)
                  ? FontWeight.bold
                  : FontWeight.normal,
            )),
        nextStyle: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(Colors.blueAccent),
        ),
        done:
            const Text("Accedi", style: TextStyle(fontWeight: FontWeight.w600)),
        doneStyle: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(Colors.blueAccent),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: ThemesUtil.getPrimaryColor(context),
          color: CupertinoColors.systemGrey,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
