import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/firebase_options.dart';
import 'package:app_word/screens/main/main_page.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppWord());
}

class AppWord extends StatelessWidget {
  const AppWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = "AppWord";

    Widget home = FirebaseGlobal.auth.currentUser != null
        ? FirebaseGlobal.auth.currentUser!.emailVerified
            ? const MainPage()
            : const Text(
                "Email verification page") //TODO: Insert email verification page
        : const Text("OnBoardingActivity"); //TODO: Insert OnBoarding page

    CupertinoApp cupertinoApp = CupertinoApp(
      title: title,
      theme: Theme.of(context).brightness == Brightness.light
          ? CupertinoThemes.lightThemeCupertino
          : CupertinoThemes.darkThemeCupertino,
      home: home,
    );
    MaterialApp materialApp = MaterialApp(
      title: title,
      theme: Theme.of(context).brightness == Brightness.light
          ? MaterialTheme.lightTheme
          : MaterialTheme.darkTheme,
      home: home,
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? cupertinoApp
        : materialApp;
  }
}
