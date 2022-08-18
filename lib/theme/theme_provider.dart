import 'dart:developer';

import 'package:app_word/theme/theme_preference.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _isDarkTheme = false;
  String _theme = ThemePreference.SYSTEM_THEME;

  bool get isDarkTheme => _isDarkTheme;

  String get theme => _theme;

  set theme(String value) {
    _isDarkTheme = value == ThemePreference.SYSTEM_THEME
        ? WidgetsBinding.instance.window.platformBrightness == Brightness.light
            ? false
            : true
        : value == ThemePreference.LIGHT_THEME
            ? false
            : true;
    themePreference.setTheme(value);
    _theme = value;
    notifyListeners();
  }
}
