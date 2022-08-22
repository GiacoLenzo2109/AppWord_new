import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/book.dart';
import 'package:app_word/theme/theme_preference.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/screens/main/home.dart';
import 'package:app_word/screens/main/main_page.dart';
import 'package:app_word/screens/main/settings.dart';
import 'package:app_word/util/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //options: DefaultFirebaseOptions.currentPlatform,
  //);
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then(
  //   (value) =>
  // );
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
  ThemeProvider themeProvider = ThemeProvider();

  void getCurrentAppTheme() async {
    themeProvider.theme = await themeProvider.themePreference.getTheme();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getCurrentAppTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() async {
        if (await themeProvider.themePreference.getTheme() ==
            ThemePreference.SYSTEM_THEME) {
          // themeProvider.theme =
          //     WidgetsBinding.instance.window.platformBrightness ==
          //             Brightness.dark
          //         ? ThemePreference.DARK_THEME
          //         : ThemePreference.LIGHT_THEME;
          themeProvider.theme = ThemePreference.SYSTEM_THEME;
        }
      });
    }

    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    String title = "AppWord";

    Widget home() => //FirebaseGlobal.auth.currentUser == null
        //? FirebaseGlobal.auth.currentUser!.emailVerified
        const MainPage();
    // : const Text(
    //     "Email verification page"); //TO-DO: Insert email verification page
    //: const Text("OnBoardingActivity"); //TO-DO: Insert OnBoarding page

    //iOS
    CupertinoApp cupertinoApp() => CupertinoApp(
          title: title,
          theme: themeProvider.isDarkTheme
              ? CupertinoThemes.darkThemeCupertino
              : CupertinoThemes.lightThemeCupertino,
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          home: home(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => const Home(),
            '/book': (BuildContext context) => const Book(),
            '/settings': (BuildContext context) => const Settings(),
          },
        );

    //ANDROID
    MaterialApp materialApp() => MaterialApp(
          title: title,
          theme: MaterialTheme.lightTheme,
          darkTheme: MaterialTheme.darkTheme,
          themeMode:
              themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: home(),
        );

    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, value, Widget? child) =>
            Theme.of(context).platform == TargetPlatform.iOS
                ? cupertinoApp()
                : materialApp(),
      ),
    );
  }
}
