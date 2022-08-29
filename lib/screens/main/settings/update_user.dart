import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/user_repository.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/global_func.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UpdateUserPage extends StatefulWidget {
  static const USERNAME = "Username";
  static const EMAIL = "Email";
  static const PASSWORD = "Password";

  final String type;

  const UpdateUserPage({Key? key, required this.type}) : super(key: key);

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassController = TextEditingController();

  var error = "";

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      scrollable: false,
      title: "Aggiorna ${widget.type}",
      body: StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 25,
        children: [
          if (widget.type == UpdateUserPage.USERNAME)
            TextFieldWidget(
              controller: usernameController,
              placeholder:
                  FirebaseGlobal.auth.currentUser?.displayName ?? widget.type,
              icon: CupertinoIcons.person,
              type: TextInputType.text,
            ),
          if (widget.type == UpdateUserPage.EMAIL)
            TextFieldWidget(
              controller: emailController,
              placeholder:
                  FirebaseGlobal.auth.currentUser?.email ?? "esempio@gmail.com",
              icon: CupertinoIcons.mail,
              type: TextInputType.text,
            ),
          if (widget.type == UpdateUserPage.PASSWORD)
            TextFieldWidget(
              controller: passwordController,
              placeholder: "Nuova password",
              icon: CupertinoIcons.lock,
              type: TextInputType.visiblePassword,
              isPassword: true,
            ),
          if (widget.type == UpdateUserPage.PASSWORD)
            TextFieldWidget(
              controller: confirmPassController,
              placeholder: "Conferma password",
              icon: CupertinoIcons.lock,
              type: TextInputType.visiblePassword,
              isPassword: true,
            ),
          const SizedBox(
            height: 10,
          ),
          ButtonWidget(
            text: "Aggiorna",
            onPressed: () async {
              setState(() {
                error = "";
              });
              switch (widget.type) {
                case UpdateUserPage.USERNAME:
                  log("1. Aggiornamento username");
                  if (usernameController.text.isNotEmpty) {
                    LoadingWidget.show(context);
                    await FirebaseGlobal.auth.currentUser!.updateDisplayName(
                      usernameController.text.trim(),
                    );
                    log("2. Username aggiornato");
                  } else {
                    setState(() {
                      error = "Username non valido!";
                    });
                    log("2. $error");
                  }
                  break;
                case UpdateUserPage.EMAIL:
                  if (emailController.text.isNotEmpty &&
                      GlobalFunc.isEmail(emailController.text)) {
                    log("1. Change email");
                    var freeEmail = await UserRepository.isEmailFree(
                        context: context, email: emailController.text);

                    if (!freeEmail) {
                      setState(() {
                        error = "Email già in uso!";
                        log("3. $error");
                      });
                    } else {
                      log("2. Start email");
                      LoadingWidget.show(context);
                      try {
                        await FirebaseGlobal.auth.currentUser!
                            .updateEmail(emailController.text.trim())
                            .whenComplete(
                              () => FirebaseGlobal.auth.currentUser!
                                  .sendEmailVerification(),
                            );
                        log("3. Email changed");
                      } on Exception catch (e) {
                        setState(() {
                          error = "Email non valida!";
                        });
                        log("3. $error");
                      }
                    }
                  } else {
                    setState(() {
                      error = "Email non valida!";
                    });
                    DialogUtil.openDialog(
                      context: context,
                      builder: (context) => ErrorDialogWidget(error),
                    );
                  }
                  break;
                case UpdateUserPage.PASSWORD:
                  if (passwordController.text.isNotEmpty &&
                      passwordController.text == confirmPassController.text) {
                    log("1. Aggiornamento password");
                    LoadingWidget.show(context);
                    await FirebaseGlobal.auth.currentUser!
                        .updatePassword(passwordController.text);
                    log("2. Password aggiornata");
                  } else {
                    setState(() {
                      error = passwordController.text.isEmpty
                          ? "Inserisci una password!"
                          : "Le password non combaciano!";
                    });
                    log("2. $error");
                  }
                  break;
              }

              if (error.isEmpty) {
                await UserRepository.updateUser(
                        context: context,
                        user: FirebaseGlobal.auth.currentUser!)
                    .whenComplete(
                  () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              } else {
                DialogUtil.openDialog(
                  context: context,
                  builder: (context) => ErrorDialogWidget(error),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
