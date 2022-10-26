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
  bool isGoogleUser = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (FirebaseGlobal.auth.currentUser != null) {
      for (var prov in FirebaseGlobal.auth.currentUser!.providerData) {
        log(prov.providerId);
        if (prov.providerId == 'google.com') {
          isGoogleUser = true;
          break;
        }
      }
    }

    return PageScaffold(
      title: "Impostazioni",
      scrollable: true,
      padding: 0,
      child: Column(
        // crossAxisCount: 1,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 400,
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
                      title: Text(
                        'Username',
                        style:
                            TextStyle(color: ThemesUtil.getTextColor(context)),
                      ),
                      onPressed: (context) => NavigatorUtil.navigateToNamed(
                        context: NavigationService.navigatorKey.currentContext!,
                        route: NavigatorUtil.CHANGE_USERNAME,
                      ),
                    ),
                    if (!AuthenticationRepository.isGoogleLogged())
                      SettingsTile.navigation(
                        leading: const Icon(CupertinoIcons.mail),
                        title: Text(
                          'Email',
                          style: TextStyle(
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                        onPressed: (context) => NavigatorUtil.navigateToNamed(
                          context:
                              NavigationService.navigatorKey.currentContext!,
                          route: NavigatorUtil.CHANGE_EMAIL,
                        ),
                      ),
                    if (!AuthenticationRepository.isGoogleLogged())
                      SettingsTile.navigation(
                        leading: const Icon(CupertinoIcons.lock),
                        title: Text(
                          'Cambia password',
                          style: TextStyle(
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                        onPressed: (context) => NavigatorUtil.navigateToNamed(
                          context:
                              NavigationService.navigatorKey.currentContext!,
                          route: NavigatorUtil.CHANGE_PASSWORD,
                        ),
                      ),
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.trash),
                      title: Text(
                        'Cambia password',
                        style: TextStyle(
                          color: ThemesUtil.getTextColor(context),
                        ),
                      ),
                      onPressed: (context) => NavigatorUtil.navigateToNamed(
                        context: NavigationService.navigatorKey.currentContext!,
                        route: NavigatorUtil.CHANGE_PASSWORD,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      onPressed: (context) {
                        return DialogUtil.openDialog(
                          context: context,
                          builder: (context) => DialogWidget(
                            body: StaggeredGrid.count(
                              crossAxisCount: 3,
                              children: [
                                IconButtonWidget(
                                  onPressed: () {
                                    themeProvider.theme =
                                        ThemePreference.LIGHT_THEME;
                                  },
                                  icon: Icon(
                                    CupertinoIcons.brightness_solid,
                                    color: themeProvider.theme ==
                                            ThemePreference.LIGHT_THEME
                                        ? Colors.amber
                                        : Colors.grey,
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
                                        ? Colors.blueAccent
                                        : Colors.grey,
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
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            title:
                                "Tema: ${themeProvider.isDarkTheme ? "Scuro" : "Chiaro"}",
                          ),
                        );
                      },
                      leading: const Icon(CupertinoIcons.paintbrush),
                      title: Text(
                        "Tema: ${themeProvider.isDarkTheme ? "Scuro" : "Chiaro"}",
                        style:
                            TextStyle(color: ThemesUtil.getTextColor(context)),
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      title: Text(
                        "About",
                        style:
                            TextStyle(color: ThemesUtil.getTextColor(context)),
                      ),
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
          StaggeredGrid.count(
            crossAxisCount: 1,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ButtonWidget(
                  text: "Esci",
                  backgroundColor: CupertinoColors.systemRed,
                  onPressed: () async {
                    await AuthenticationRepository.signOut(
                        context:
                            NavigationService.navigatorKey.currentContext!);
                    NavigatorUtil.navigateAndReplace(
                      context: NavigationService.navigatorKey.currentContext!,
                      route: NavigatorUtil.SIGNIN,
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
