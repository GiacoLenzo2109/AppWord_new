import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Global {
  static Widget buildContainer(BuildContext context, Widget child) {
    return StaggeredGridTile.fit(
      crossAxisCellCount: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).platform == TargetPlatform.android
              ? Theme.of(context).backgroundColor
              : CupertinoThemes.backgroundColor(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: child,
        ),
      ),
    );
  }
}
