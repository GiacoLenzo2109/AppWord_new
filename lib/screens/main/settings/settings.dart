import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/screens/signin/signin_page.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/theme/theme_preference.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/database/repository/authentication_repository.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/icon_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../widgets/global/scaffold_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isGoogleUser = FirebaseGlobal.auth.currentUser != null
      ? FirebaseGlobal.auth.currentUser!.providerData[0].providerId ==
          'google.com'
      : false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return PageScaffold(
      title: "Impostazioni",
      scrollable: false,
      padding: 0,
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        children: [
          SizedBox(
            height: ScreenUtil.getSize(context).height - 325,
            child: SettingsList(
              physics: const NeverScrollableScrollPhysics(),
              lightTheme: const SettingsThemeData(
                settingsListBackground: Colors.transparent,
              ),
              darkTheme: const SettingsThemeData(
                settingsListBackground: Colors.transparent,
              ),
              platform: Theme.of(context).platform == TargetPlatform.iOS
                  ? DevicePlatform.iOS
                  : DevicePlatform.android,
              applicationType: ApplicationType.both,
              sections: [
                SettingsSection(
                  title: const Text('Account'),
                  tiles: <SettingsTile>[
                    //if (!AuthenticationRepository.isGoogleLogged())
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.person),
                      title: const Text('Username'),
                      onPressed: (context) => NavigatorUtil.navigateToNamed(
                        context: NavigationService.navigatorKey.currentContext!,
                        route: NavigatorUtil.CHANGE_USERNAME,
                      ),
                    ),
                    if (!AuthenticationRepository.isGoogleLogged())
                      SettingsTile.navigation(
                        leading: const Icon(CupertinoIcons.mail),
                        title: const Text('Email'),
                        onPressed: (context) => NavigatorUtil.navigateToNamed(
                          context:
                              NavigationService.navigatorKey.currentContext!,
                          route: NavigatorUtil.CHANGE_EMAIL,
                        ),
                      ),
                    if (!AuthenticationRepository.isGoogleLogged())
                      SettingsTile.navigation(
                        leading: const Icon(CupertinoIcons.lock),
                        title: const Text('Cambia password'),
                        onPressed: (context) => NavigatorUtil.navigateToNamed(
                          context:
                              NavigationService.navigatorKey.currentContext!,
                          route: NavigatorUtil.CHANGE_PASSWORD,
                        ),
                      ),
                  ],
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      onPressed: (_) => DialogUtil.openDialog(
                        context: context,
                        builder: (context) => DialogWidget(
                          body: StaggeredGrid.count(
                            crossAxisCount: 3,
                            children: [
                              IconButtonWidget(
                                onPressed: () {
                                  themeProvider.theme =
                                      ThemePreference.LIGHT_THEME;
                                  //Navigator.pop(context);
                                },
                                icon: Icon(
                                  CupertinoIcons.brightness_solid,
                                  color: themeProvider.theme ==
                                          ThemePreference.LIGHT_THEME
                                      ? Colors.amber
                                      : null,
                                ),
                              ),
                              IconButtonWidget(
                                onPressed: () {
                                  themeProvider.theme =
                                      ThemePreference.DARK_THEME;
                                  //Navigator.pop(context);
                                },
                                icon: Icon(
                                  CupertinoIcons.moon_fill,
                                  color: themeProvider.theme ==
                                          ThemePreference.DARK_THEME
                                      ? Colors.grey
                                      : null,
                                ),
                              ),
                              IconButtonWidget(
                                onPressed: () {
                                  themeProvider.theme =
                                      ThemePreference.SYSTEM_THEME;
                                  //Navigator.pop(context);
                                },
                                icon: Icon(
                                  CupertinoIcons.device_phone_portrait,
                                  color: themeProvider.theme ==
                                          ThemePreference.SYSTEM_THEME
                                      ? Colors.orange
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          title:
                              "Tema: ${themeProvider.isDarkTheme ? "Scuro" : "Chiaro"}",
                        ),
                      ),
                      leading: const Icon(CupertinoIcons.paintbrush),
                      title: Text(
                        "Tema: ${themeProvider.isDarkTheme ? "Scuro" : "Chiaro"}",
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: const Text("About"),
                      leading: const Icon(CupertinoIcons.info),
                      onPressed: (context) => NavigatorUtil.navigateToNamed(
                        context: NavigationService.navigatorKey.currentContext!,
                        route: NavigatorUtil.ABOUT,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ButtonWidget(
              text: "Logout",
              backgroundColor: CupertinoColors.systemRed,
              onPressed: () async {
                await AuthenticationRepository.signOut(
                    context: NavigationService.navigatorKey.currentContext!);
                NavigatorUtil.navigateAndReplace(
                  context: NavigationService.navigatorKey.currentContext!,
                  route: NavigatorUtil.SIGNIN,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
