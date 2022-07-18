import 'package:app_word/util/constants.dart';
import 'package:app_word/util/global.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/button_widget.dart';
import 'package:app_word/widgets/container_widget.dart';
import 'package:app_word/widgets/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dart:math' as math;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> newWords = [];

    for (int i = 0; i < 5; i++) {
      newWords.add(ButtonWidget(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        text: (i + 1).toString(),
      ));
    }

    return RefreshIndicator(
      color: Colors.greenAccent,
      onRefresh: () async {},
      child: PageScaffold(
        title: "Home",
        scrollable: true,
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 25,
          children: [
            // New word
            ContaienrWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Parola del giorno:",
                          style: ThemesUtil.titleContainerStyle(context),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                            width: ScreenUtil.getSize(context).width / 2,
                            child: Text(
                              "Paroladelgiornooooooo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Theme.of(context).platform ==
                                        TargetPlatform.android
                                    ? Theme.of(context).primaryColor
                                    : CupertinoTheme.of(context).primaryColor,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.amber[400],
                    child: Padding(
                      padding: Constants.padding,
                      child: Icon(
                        Icons.lightbulb_rounded,
                        size: ScreenUtil.getSize(context).height / 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Rubriche
            ContaienrWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                children: [
                  Text(
                    "Rubriche:",
                    style: ThemesUtil.titleContainerStyle(context),
                  ),
                  Container(
                    margin: const EdgeInsets.all(7.5),
                    color: Colors.grey,
                    height: 1,
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    children: const [
                      ButtonWidget(
                          backgroundColor: Colors.red,
                          text: Constants.personalBook),
                      ButtonWidget(
                        backgroundColor: CupertinoColors.activeBlue,
                        text: Constants.classBook,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Lista nuove parole
            ContaienrWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                children: [
                  Text(
                    "Nuove parole:",
                    style: ThemesUtil.titleContainerStyle(context),
                  ),
                  Container(
                    margin: const EdgeInsets.all(7.5),
                    color: Colors.grey,
                    height: 1,
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    children: newWords,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
