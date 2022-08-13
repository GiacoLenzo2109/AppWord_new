import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme =
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark
          ? true
          : false;
  //Cambiare al tema memorizzato nelle SharedPrafarences

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !isDarkTheme;
  }
}
