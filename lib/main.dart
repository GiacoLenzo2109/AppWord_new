import 'dart:js';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/firebase_options.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/providers/theme_provider.dart';
import 'package:app_word/screens/main/book.dart';
import 'package:app_word/screens/main/home.dart';
import 'package:app_word/screens/main/main_page.dart';
import 'package:app_word/screens/main/settings.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const AppWord()));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NavbarModel()),
      ],
      builder: (context, _) => const AppWord(),
    ),
  );
}

class AppWord extends StatefulWidget {
  const AppWord({Key? key}) : super(key: key);

  @override
  State<AppWord> createState() => _AppWordState();
}

class _AppWordState extends State<AppWord> with WidgetsBindingObserver {
  Brightness? _brightness;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    String title = "AppWord";

    Widget home() => FirebaseGlobal.auth.currentUser == null
        //? FirebaseGlobal.auth.currentUser!.emailVerified
        ? const MainPage()
        : const Text(
            "Email verification page"); //TO-DO: Insert email verification page
    //: const Text("OnBoardingActivity"); //TO-DO: Insert OnBoarding page

    //iOS
    CupertinoApp cupertinoApp = CupertinoApp(
      title: title,
      theme: _brightness == Brightness.light
          ? CupertinoThemes.lightThemeCupertino
          : CupertinoThemes.darkThemeCupertino,
      home: home(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const Home(),
        '/book': (BuildContext context) => const Book(),
        '/settings': (BuildContext context) => const Settings(),
      },
    );

    //ANDROID
    MaterialApp materialApp = MaterialApp(
      title: title,
      // theme: _brightness == Brightness.light
      //     ? MaterialTheme.lightTheme
      //     : MaterialTheme.darkTheme,
      theme: MaterialTheme.lightTheme,
      darkTheme: MaterialTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: home(),
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? cupertinoApp
        : materialApp;
  }
}
