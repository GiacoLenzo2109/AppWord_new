import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:material_dialogs/material_dialogs.dart';

class OnBoardingPages {
  static build(BuildContext context) {
    return [
      OnBoardingPage.build(
        context: context,
        title: "Memorizza i vocaboli",
        body:
            "Puoi creare una rubrica nel quale salvare tutti i vocaboli che hai bisogno di memorizzare.",
        animation: "assets/animations/brain.json",
      ),
      OnBoardingPage.build(
        context: context,
        title: "Lavora in squadra",
        body:
            "Entra a far parte di una rubrica condivisa e collabora con i tuoi amici.",
        animation: "assets/animations/teamwork.json",
      ),
      OnBoardingPage.build(
        context: context,
        title: "Continua a crescere",
        body:
            "Ogni giorno troverai un nuovo vocabolo che potrai consultare ed aggiungere al tuo bagaglio delle conoscenze.",
        animation: "assets/animations/student.json",
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
    String? animation,
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
          : animation != null
              ? LottieBuilder.asset(animation)
              : null,
    );
  }
}
