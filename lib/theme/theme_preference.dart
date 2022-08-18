import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const THEME_STATUS = "THEME_STATUS";
  static const DARK_THEME = "DARK_THEME";
  static const LIGHT_THEME = "LIGHT_THEME";
  static const SYSTEM_THEME = "SYSTEM_THEME";

  void setTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(THEME_STATUS, value);
  }

  Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = prefs.getString(THEME_STATUS) ?? SYSTEM_THEME;
    return theme;
  }
}
