import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/authentication_repository.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class GoogleLogInButton extends StatelessWidget {
  final String title;

  const GoogleLogInButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
        text: title,
        icon: Image.asset(
          "assets/Google_Logo.png",
          width: 25,
          fit: BoxFit.fill,
        ),
        backgroundColor: CupertinoColors.activeOrange,
        onPressed: () {
          AuthenticationRepository.signInWithGoogle(context: context);
        }

        // : DialogUtil.openDialog(
        //     context: context,
        //     builder: (context) => DialogWidget(
        //       title: "Errore!",
        //       msg: passwordController.text !=
        //               confirmPasswordController.text
        //           ? "Le password non combaciano!"
        //           : "Mail non valida!",
        //       dType: DialogType.ERROR,
        //     ),
        //   );

        );
  }
}
