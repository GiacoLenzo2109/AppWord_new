import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigatorUtil {
  static const HOME = '/home';
  static const BOOK = '/book';
  static const SETTINGS = '/settings';
  static const REGISTER = '/register';
  static const LOGIN = '/login';
  static const SIGNIN = '/singin';
  static const EMAIL_VERIFICATION = '/email_verification';

  static navigateTo(
      {required BuildContext context,
      required Widget Function(BuildContext) builder}) {
    Navigator.of(context).push(
      Theme.of(context).platform == TargetPlatform.android
          ? MaterialPageRoute(builder: builder)
          : CupertinoPageRoute(builder: builder),
    );
  }

  static navigateAndReplace(
      {required BuildContext context, required String route}) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
