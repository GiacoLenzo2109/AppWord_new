import 'package:app_word/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigatorUtil {
  static const MAIN = '/main';
  static const HOME = '/home';
  static const BOOK = '/book';
  static const SETTINGS = '/settings';
  static const REGISTER = '/register';
  static const LOGIN = '/login';
  static const SIGNIN = '/singin';
  static const EMAIL_VERIFICATION = '/email_verification';
  static const CHANGE_EMAIL = '/change_email';
  static const CHANGE_USERNAME = '/change_username';
  static const CHANGE_PASSWORD = '/change_password';
  static const ABOUT = '/about';

  static makeRoute({required BuildContext context, required Widget page}) =>
      Theme.of(context).platform == TargetPlatform.android
          ? MaterialPageRoute(builder: (context) => page)
          : CupertinoPageRoute(builder: (context) => page);

  static navigateTo(
      {required BuildContext context,
      required Widget Function(BuildContext) builder,
      bool? isOnRoot}) {
    var _context = isOnRoot != null && isOnRoot
        ? NavigationService.navigatorKey.currentContext!
        : context;

    Navigator.of(_context).push(
      Theme.of(context).platform == TargetPlatform.android
          ? MaterialPageRoute(builder: builder)
          : CupertinoPageRoute(builder: builder),
    );
  }

  static navigateToNamed(
      {required BuildContext context, required String route}) {
    Navigator.of(context).pushNamed(route);
  }

  static navigateAndReplace(
      {required BuildContext context, required String route}) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  static navigatePopAndGo(
      {required BuildContext context, required String route}) {
    Navigator.of(context).popAndPushNamed(route);
  }

  static navigatePopGo({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    Navigator.of(context).pop();
    navigateTo(context: context, builder: builder);
  }
}
