import 'dart:developer';

import 'package:app_word/providers/theme_provider.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../widgets/global/scaffold_widget.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return PageScaffold(
      title: "Impostazioni",
      scrollable: false,
      padding: 0,
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        children: [
          SizedBox(
            height: ScreenUtil.getSize(context).height / 3,
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: const Text('Account'),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.mail),
                      title: const Text('Email'),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.lock),
                      title: const Text('Cambia password'),
                    ),
                  ],
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    SettingsTile.switchTile(
                      onToggle: (value) {
                        themeProvider.toggleTheme();
                        log(themeProvider.isDarkTheme.toString());
                      },
                      onPressed: (context) => {
                        themeProvider.toggleTheme(),
                        log(themeProvider.isDarkTheme.toString()),
                      },
                      initialValue: themeProvider.isDarkTheme,
                      leading: const Icon(CupertinoIcons.paintbrush),
                      title: const Text('Tema scuro'),
                      enabled: themeProvider.isDarkTheme,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ButtonWidget(
            text: "Logout",
            backgroundColor: CupertinoColors.systemRed,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
