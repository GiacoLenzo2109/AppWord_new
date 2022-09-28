import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/screens/main/main_page.dart';
import 'package:app_word/screens/signin/register_page.dart';
import 'package:app_word/database/repository/authentication_repository.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/global_func.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/icon_button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:app_word/widgets/global/text_field_tags.dart';
import 'package:app_word/widgets/singin/google_login_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var error = "";

    bool areValidFields() {
      if (!GlobalFunc.isEmail(emailController.text)) {
        error = "Email non valida";
      }
      if (passwordController.text.isEmpty) {
        error = "Password non valida";
      }
      return GlobalFunc.isEmail(emailController.text) &&
          passwordController.text.isNotEmpty;
    }

    var child = Padding(
      padding: const EdgeInsets.all(25),
      child: Center(
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 50,
          children: [
            StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 15,
              children: const [
                Text(
                  "Bentornato!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
                Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
              ],
            ),
            StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 15,
              children: [
                TextFieldWidget(
                  controller: emailController,
                  placeholder: "Email",
                  icon: CupertinoIcons.mail,
                ),
                TextFieldWidget(
                  controller: passwordController,
                  placeholder: "Password",
                  icon: CupertinoIcons.lock,
                  isPassword: true,
                ),
              ],
            ),
            StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 15,
              children: [
                ButtonWidget(
                  text: "Login",
                  onPressed: () {
                    areValidFields()
                        ? AuthenticationRepository.signInWithEmailAndPassword(
                            context: context,
                            email: emailController.text,
                            password: passwordController.text,
                          )
                        : DialogUtil.openDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                              "Mail o password errati!",
                            ),
                          );
                  },
                ),
                const Divider(
                  color: CupertinoColors.systemGrey,
                ),
                const GoogleLogInButton(title: "Accedi con Google"),
              ],
            ),
            StaggeredGrid.count(
              crossAxisCount: 1,
              children: [
                const Text(
                  "Non hai ancora un account?",
                  textAlign: TextAlign.center,
                ),
                ButtonWidget(
                  text: "Registrati",
                  backgroundColor: ThemesUtil.getBackgroundColor(context),
                  textColor: CupertinoColors.activeBlue,
                  onPressed: () => Navigator.canPop(context)
                      ? NavigatorUtil.navigatePopAndGo(
                          context: context, route: NavigatorUtil.REGISTER)
                      : NavigatorUtil.navigateTo(
                          context: context,
                          builder: (context) => const RegisterPage(),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    return SimplePageScaffold(
      scrollable: false,
      padding: 0,
      body: child,
      backgroundColor: ThemesUtil.getBackgroundColor(context),
      titleColor: ThemesUtil.getContrastingColor(context),
    );
  }
}
