import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
      backgroundColor: Color.fromARGB(255, 39, 108, 255),
    ),
    bottomAppBarColor: CupertinoColors.darkBackgroundGray,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.black,
      selectedItemColor: const Color.fromARGB(255, 39, 108, 255),
      unselectedItemColor: Colors.grey[350],
    ),
    primaryColor: const Color.fromARGB(255, 39, 108, 255),
    primaryColorDark: Colors.white,
    primaryColorLight: CupertinoColors.darkBackgroundGray,
  );
}

///Cupertino themes - Apple themes (light/dark)
class CupertinoThemes {
  static CupertinoThemeData lightThemeCupertino = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: CupertinoColors.darkBackgroundGray,
    scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
    barBackgroundColor: Colors.white.withOpacity(0.50),
  );
  static CupertinoThemeData darkThemeCupertino = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: Colors.white,
    scaffoldBackgroundColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.darkBackgroundGray.withOpacity(0.50),
  );

  static Color? backgroundColor(BuildContext context) =>
      CupertinoTheme.brightnessOf(context) == Brightness.dark
          ? CupertinoColors.darkBackgroundGray
          : Colors.white;
}
