import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPages {
  static build(BuildContext context) {
    return [
      OnBoardingPage.build(
        context: context,
        title: "Memorizza",
        body:
            "Crea la tua rubrica personale ed impara vocaboli che non conosci!",
        image: "assets/Google_Logo.png",
      ),
      OnBoardingPage.build(
        context: context,
        title: "Condividi",
        body:
            "Entra a far parte di una rubrica ed inizia ad annotare vocaboli!",
        image: "assets/Google_Logo.png",
      ),
      OnBoardingPage.build(
        context: context,
        title: "Collabora",
        body: "Collabora con i tuoi amici ed amplia le tue conoscenze!",
        image: "assets/Google_Logo.png",
      ),
    ];
  }
}

class OnBoardingPage {
  static PageViewModel build({
    required BuildContext context,
    required String title,
    required String body,
    String? image,
  }) {
    return PageViewModel(
      title: title,
      body: body,
      decoration: PageDecoration(
        imageFlex: 3,
        bodyFlex: 2,
        imageAlignment: Alignment.bottomCenter,
        bodyAlignment: Alignment.topCenter,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
          color: ThemesUtil.getTextColor(context),
        ),
        bodyTextStyle: TextStyle(
          color: ThemesUtil.getTextColor(context),
        ),
      ),
      image: image != null
          ? Image.asset(
              image,
              width: ScreenUtil.getSize(context).width - 100,
            )
          : null,
    );
  }
}
