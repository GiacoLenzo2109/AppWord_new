import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemesUtil {
  static bool isAndroid(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;
  static Color getContrastingColor(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android
          ? Theme.of(context).primaryColorDark
          : CupertinoTheme.of(context).primaryContrastingColor;

  static TextStyle titleContainerStyle(context) => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Theme.of(context).platform == TargetPlatform.android
            ? Theme.of(context).primaryColorDark
            : CupertinoTheme.of(context).primaryContrastingColor,
      );

  static getThemes(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android
          ? Theme.of(context)
          : CupertinoTheme.of(context);

  static Color getPrimaryColor(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android
          ? Theme.of(context).primaryColor
          : CupertinoTheme.of(context).primaryColor;

  static Color getTextColor(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android
          ? Theme.of(context).primaryColorDark
          : CupertinoTheme.of(context).primaryContrastingColor;

  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android
          ? Theme.of(context).scaffoldBackgroundColor
          : CupertinoTheme.of(context).scaffoldBackgroundColor;
}

///Material themes (light/dark)
class MaterialTheme {
  static ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[100],
    colorScheme: const ColorScheme.light(),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25.0),
      backgroundColor: Color.fromARGB(255, 39, 108, 255),
    ),
    bottomAppBarColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.grey[100],
      selectedItemColor: const Color.fromARGB(255, 39, 108, 255),
      unselectedItemColor: Colors.grey[350],
    ),
    primaryColor: const Color.fromARGB(255, 39, 108, 255),
    primaryColorDark: Colors.grey[800],
    primaryColorLight: Colors.white,
  );

  static ThemeData darkTheme = ThemeData(
    backgroundColor: CupertinoColors.darkBackgroundGray,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
      ),
      backgroundColor: Color.fromARGB(255, 39, 108, 255),
    ),
    bottomAppBarColor: Colors.black,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.black,
      selectedItemColor: const Color.fromARGB(255, 39, 108, 255),
      unselectedItemColor: Colors.grey[350],
    ),
    primaryColor: const Color.fromARGB(255, 39, 108, 255),
    primaryColorDark: Colors.white,
    primaryColorLight: Colors.black,
  );
}

///Cupertino themes - Apple themes (light/dark)
class CupertinoThemes {
  static CupertinoThemeData lightThemeCupertino = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: CupertinoColors.darkBackgroundGray,
    scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
    barBackgroundColor:
        CupertinoColors.extraLightBackgroundGray.withOpacity(0.50),
  );
  static CupertinoThemeData darkThemeCupertino = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: Colors.white,
    scaffoldBackgroundColor: Color.fromARGB(255, 17, 17, 17),
    barBackgroundColor: CupertinoColors.darkBackgroundGray,
    textTheme:
        CupertinoTextThemeData(textStyle: TextStyle(color: Colors.white)),
  );

  static Color? backgroundColor(BuildContext context) =>
      CupertinoTheme.brightnessOf(context) == Brightness.dark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.white;
}
