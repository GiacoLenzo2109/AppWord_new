import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Material themes (light/dark)
class MaterialTheme {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: const ColorScheme.light(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25.0),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[350],
      ),
      primaryColorDark: Colors.grey[800],
      primaryColorLight: Colors.grey[100]);

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey,
      colorScheme: const ColorScheme.dark(),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[350],
      ),
      primaryColorDark: Colors.white,
      primaryColorLight: Colors.grey[800]);
}

///Cupertino themes - Apple themes (light/dark)
class CupertinoThemes {
  static CupertinoThemeData lightThemeCupertino = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: Colors.grey[800],
    scaffoldBackgroundColor: Colors.grey[100],
    barBackgroundColor: Colors.white.withOpacity(0.50),
  );
  static CupertinoThemeData darkThemeCupertino = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: Colors.white,
    scaffoldBackgroundColor: CupertinoColors.systemGrey,
    barBackgroundColor: CupertinoColors.systemGrey.withOpacity(0.50),
  );
}
