import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/screens/main/main_page.dart';
import 'package:app_word/screens/signin/email_verification_page.dart';
import 'package:app_word/screens/signin/login_page.dart';
import 'package:app_word/util/authentication.dart';
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
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var error = "";

    void register({required String email, required String password}) async {
      try {
        await FirebaseGlobal.auth
            .createUserWithEmailAndPassword(email: email, password: password);
        if (FirebaseGlobal.auth.currentUser != null) {
          DialogUtil.openDialog(
            context: context,
            builder: (context) => const LoadingWidget(),
          );
          await FirebaseGlobal.auth.currentUser!.sendEmailVerification();
          () => NavigatorUtil.navigateAndReplace(
                context: context,
                route: NavigatorUtil.EMAIL_VERIFICATION,
              );
        }
      } on FirebaseAuthException catch (e) {
        log(e.code);
        if (e.code == 'user-not-found') {
          error = 'Email o password sbagliata!';
        } else if (e.code == 'wrong-password') {
          error = 'Password sbagliata, riprova!';
        }
        DialogUtil.openDialog(
          context: context,
          builder: (context) => ErrorDialogWidget(error),
        );
      } catch (e) {
        log(e.toString());
      }
    }

    bool areValidFields() {
      return GlobalFunc.isEmail(emailController.text) &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          passwordController.text == confirmPasswordController.text;
    }

    return SimplePageScaffold(
      body: Padding(
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
                    "Benvenuto!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  Text(
                    "Registrazione",
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
                  TextFieldWidget(
                    controller: confirmPasswordController,
                    placeholder: "Conferma password",
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
                    text: "Registrati",
                    onPressed: () {
                      areValidFields()
                          ? register(
                              email: emailController.text,
                              password: passwordController.text,
                            )
                          : DialogUtil.openDialog(
                              context: context,
                              builder: (context) => DialogWidget(
                                title: "Errore!",
                                msg: passwordController.text !=
                                        confirmPasswordController.text
                                    ? "Le password non combaciano!"
                                    : "Mail non valida!",
                                dType: DialogType.ERROR,
                              ),
                            );
                    },
                  ),
                  const Divider(
                    color: CupertinoColors.systemGrey,
                  ),
                  ButtonWidget(
                    text: "Registrati con Google",
                    icon: Image.asset(
                      "assets/Google_Logo.png",
                      width: 25,
                      fit: BoxFit.fill,
                    ),
                    backgroundColor: CupertinoColors.activeOrange,
                    onPressed: () {
                      Authentication.signInWithGoogle(context: context)
                          .then(
                            (value) => {
                              DialogUtil.openDialog(
                                context: context,
                                builder: (context) => const LoadingWidget(),
                              ),
                            },
                          )
                          .whenComplete(
                            () => NavigatorUtil.navigateAndReplace(
                              context: context,
                              route: NavigatorUtil.HOME,
                            ),
                          );
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
                    },
                  ),
                ],
              ),
              StaggeredGrid.count(
                crossAxisCount: 1,
                children: [
                  const Text(
                    "Possiedi già un account?",
                    textAlign: TextAlign.center,
                  ),
                  ButtonWidget(
                    text: "Login",
                    backgroundColor: Colors.transparent,
                    textColor: CupertinoColors.activeBlue,
                    onPressed: () => Navigator.canPop(context)
                        ? NavigatorUtil.navigateAndReplace(
                            context: context, route: NavigatorUtil.LOGIN)
                        : NavigatorUtil.navigateTo(
                            context: context,
                            builder: (context) => const LoginPage(),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
