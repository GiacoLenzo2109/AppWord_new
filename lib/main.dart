import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/providers/book_list_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/book.dart';
import 'package:app_word/screens/main/settings/about.dart';
import 'package:app_word/screens/main/settings/update_user.dart';
import 'package:app_word/screens/on_boarding/on_boarding.dart';
import 'package:app_word/screens/signin/email_verification_page.dart';
import 'package:app_word/screens/signin/login_page.dart';
import 'package:app_word/screens/signin/register_page.dart';
import 'package:app_word/screens/signin/signin_page.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/theme/theme_preference.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/screens/main/home.dart';
import 'package:app_word/screens/main/main_page.dart';
import 'package:app_word/screens/main/settings/settings.dart';
import 'package:app_word/util/navigator_util.dart';
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

  /// Dalay splashscreen
  // Future.delayed(
  //   const Duration(seconds: 1),
  //   () => runApp(
  //     MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(create: (context) => ThemeProvider()),
  //         ChangeNotifierProvider(create: (context) => NavbarModel()),
  //       ],
  //       builder: (context, _) => const AppWord(),
  //     ),
  //   ),
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

    Widget home() => FirebaseGlobal.auth.currentUser != null
        ? FirebaseGlobal.auth.currentUser!.emailVerified
            ? const MainPage()
            : const OnBoardingPage()
        : const OnBoardingPage();

    //iOS
    CupertinoApp cupertinoApp() => CupertinoApp(
          navigatorKey: NavigationService.navigatorKey,
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
            NavigatorUtil.MAIN: (BuildContext context) => const MainPage(),
            NavigatorUtil.HOME: (BuildContext context) => const Home(),
            NavigatorUtil.BOOK: (BuildContext context) => const BookPage(),
            NavigatorUtil.SETTINGS: (BuildContext context) => const Settings(),
            NavigatorUtil.REGISTER: (BuildContext context) =>
                const RegisterPage(),
            NavigatorUtil.LOGIN: (BuildContext context) => const LoginPage(),
            NavigatorUtil.SIGNIN: (BuildContext context) => const SignInPage(),
            NavigatorUtil.EMAIL_VERIFICATION: (BuildContext context) =>
                const EmailVerificationPage(),
            NavigatorUtil.CHANGE_USERNAME: (BuildContext context) =>
                const UpdateUserPage(type: UpdateUserPage.USERNAME),
            NavigatorUtil.CHANGE_EMAIL: (BuildContext context) =>
                const UpdateUserPage(type: UpdateUserPage.EMAIL),
            NavigatorUtil.CHANGE_PASSWORD: (BuildContext context) =>
                const UpdateUserPage(type: UpdateUserPage.PASSWORD),
            NavigatorUtil.ABOUT: (BuildContext context) => const AboutPage(),
          },
        );

    //ANDROID
    MaterialApp materialApp() => MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          title: title,
          theme: MaterialTheme.lightTheme,
          darkTheme: MaterialTheme.darkTheme,
          themeMode:
              themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: home(),
        );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => themeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => BookListProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, value, Widget? child) =>
            Theme.of(context).platform == TargetPlatform.iOS
                ? cupertinoApp()
                : materialApp(),
      ),
    );
  }
}
