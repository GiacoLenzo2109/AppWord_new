import 'dart:developer';

class GlobalFunc {
  static bool isEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static String capitalize(String value) {
    if (value.isEmpty) return value;
    if (value.length == 1) return value[0].toUpperCase();
    return value[0].toUpperCase() + value.substring(1);
  }
}
