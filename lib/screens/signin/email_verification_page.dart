import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/screens/signin/signin_page.dart';
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

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseGlobal.auth.currentUser != null &&
        FirebaseGlobal.auth.currentUser!.emailVerified) {
      NavigatorUtil.navigateAndReplace(
        context: context,
        route: NavigatorUtil.HOME,
      );
    }

    return SimplePageScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StaggeredGrid.count(
            mainAxisSpacing: 10,
            crossAxisCount: 1,
            children: [
              Lottie.asset(
                'assets/animations/email_sending.json',
                height: ScreenUtil.getSize(context).height / 2.5,
                repeat: true,
              ),
              Text(
                "Verifica account tramite il link inviato a ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ThemesUtil.getTextColor(context),
                ),
              ),
              Text(
                FirebaseGlobal.auth.currentUser != null
                    ? FirebaseGlobal.auth.currentUser!.email.toString()
                    : "esempio@gmail.com",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Non hai ricevuto la mail?"),
                  ButtonWidget(
                    text: "Invia mail",
                    padding: 10,
                    backgroundColor: Colors.transparent,
                    textColor: ThemesUtil.getPrimaryColor(context),
                    onPressed: () => FirebaseGlobal.auth.currentUser!
                        .sendEmailVerification(),
                  ),
                ],
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: CupertinoButton(
          //           color: CupertinoColors.activeGreen,
          //           pressedOpacity: 0.75,
          //           child: const Text(
          //             "Fatto",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: CupertinoColors.white,
          //                 fontSize: 18),
          //           ),
          //           onPressed: () async {
          //             //reloadUser();
          //             await FirebaseGlobal.auth.currentUser!.reload();
          //             // if (!FirebaseGlobal.auth.currentUser!.emailVerified) {
          //             //   showCupertinoDialog(
          //             //       context: context,
          //             //       builder: (context) => const ErrorDialogWidget(
          //             //           "Email non verificata!"));
          //             // } else {
          //             //   Navigator.pushNamedAndRemoveUntil(
          //             //       context, "/", (route) => false);
          //             // }
          //           }),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
