import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/authentication_repository.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLogInButton extends StatefulWidget {
  final String title;
  final bool isLogin;

  const AppleLogInButton({
    Key? key,
    required this.title,
    required this.isLogin,
  }) : super(key: key);

  @override
  State<AppleLogInButton> createState() => _AppleLogInButtonState();
}

class _AppleLogInButtonState extends State<AppleLogInButton> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
        text: widget.title,
        icon: Image.asset(
          "assets/images/Apple_Logo.png",
          width: 25,
          fit: BoxFit.fill,
        ),
        backgroundColor: CupertinoColors.black,
        onPressed: () {
          widget.isLogin
              ? AuthenticationRepository.loginWithApple(
                  context: NavigationService.navigatorKey.currentContext!,
                  username: "")
              : DialogUtil.openDialog(
                  context: context,
                  builder: (context) => DialogWidget(
                        title: "Username",
                        body: StaggeredGrid.count(
                          crossAxisCount: 1,
                          children: [
                            TextFieldWidget(
                              placeholder: "Username",
                              icon: CupertinoIcons.person,
                              controller: controller,
                            )
                          ],
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            AuthenticationRepository.signInWithApple(
                                context: NavigationService
                                    .navigatorKey.currentContext!,
                                username: controller.text);
                          }
                        },
                      ));
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
