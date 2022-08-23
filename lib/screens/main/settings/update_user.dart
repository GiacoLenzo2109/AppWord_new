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
  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      padding: 25,
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
            onPressed: () async => {
              //Navigator.pop(context)
              if (emailController.text.isNotEmpty &&
                  GlobalFunc.isEmail(emailController.text))
                {
                  LoadingWidget.show(context),
                  await FirebaseGlobal.auth.currentUser!
                      .updateEmail(emailController.text),
                }
              else
                {
                  if (widget.type == UpdateUserPage.EMAIL)
                    {
                      DialogUtil.openDialog(
                        context: context,
                        builder: (context) =>
                            const ErrorDialogWidget("Email non valida!"),
                      ),
                    }
                },
              if (usernameController.text.isNotEmpty)
                {
                  LoadingWidget.show(context),
                  await FirebaseGlobal.auth.currentUser!
                      .updateDisplayName(usernameController.text),
                }
              else
                {
                  if (widget.type == UpdateUserPage.USERNAME)
                    {
                      DialogUtil.openDialog(
                        context: context,
                        builder: (context) =>
                            const ErrorDialogWidget("Username non valido!"),
                      ),
                    }
                },
              if (passwordController.text.isNotEmpty &&
                  passwordController.text == confirmPassController.text)
                {
                  LoadingWidget.show(context),
                  await FirebaseGlobal.auth.currentUser!
                      .updatePassword(passwordController.text),
                }
              else
                {
                  if (widget.type == UpdateUserPage.PASSWORD)
                    {
                      DialogUtil.openDialog(
                        context: context,
                        builder: (context) =>
                            const ErrorDialogWidget("Password non valide!"),
                      ),
                    }
                },

              await UserRepository.updateUser(
                  context: context, user: FirebaseGlobal.auth.currentUser!),
              Navigator.pop(context),
              Navigator.pop(context),
            },
          ),
        ],
      ),
    );
  }
}
