import 'package:app_word/util/constants.dart';
import 'package:app_word/util/global.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/button_widget.dart';
import 'package:app_word/widgets/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: "Home",
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 25,
          children: [
            // New word
            Global.buildContainer(
              context,
              Row(
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Theme.of(context).platform ==
                                    TargetPlatform.android
                                ? Theme.of(context).primaryColorDark
                                : CupertinoTheme.of(context)
                                    .primaryContrastingColor,
                          ),
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
            Global.buildContainer(
              context,
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                children: [
                  Text(
                    "Runbiche:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Theme.of(context).platform ==
                              TargetPlatform.android
                          ? Theme.of(context).primaryColorDark
                          : CupertinoTheme.of(context).primaryContrastingColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(7.5),
                    color: Colors.grey,
                    height: 1,
                  ),
                  const ButtonWidget(
                      backgroundColor: Colors.red,
                      text: Constants.personalBook),
                  const ButtonWidget(
                    backgroundColor: CupertinoColors.activeBlue,
                    text: Constants.classBook,
                  ),
                ],
              ),
            ),
            //Lista nuove parole
            Global.buildContainer(
              context,
              StaggeredGrid.count(
                crossAxisCount: 1,
                children: [
                  ListView.builder(
                    itemCount: 10,
                    itemBuilder: ((context, index) => Text(index.toString())),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
