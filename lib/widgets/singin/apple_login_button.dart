import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/authentication_repository.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLogInButton extends StatelessWidget {
  final String title;

  const AppleLogInButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () async {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      },
    );
  }
}
