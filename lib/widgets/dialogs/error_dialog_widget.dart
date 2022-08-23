import 'dart:ui';

import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ErrorDialogWidget extends StatefulWidget {
  final String text;

  const ErrorDialogWidget(this.text, {Key? key}) : super(key: key);

  @override
  State<ErrorDialogWidget> createState() => _ErrorDialogWidgetState();
}

class _ErrorDialogWidgetState extends State<ErrorDialogWidget> {
  @override
  void initState() {
    Future.delayed(
        const Duration(milliseconds: 1500), () => Navigator.pop(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: Constants.padding,
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: Constants.padding,
              width: ScreenUtil.getSize(context).width - 100,
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: Constants.padding,
                child: StaggeredGrid.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 15,
                  children: [
                    const Icon(
                      CupertinoIcons.xmark_circle,
                      color: Colors.redAccent,
                      size: 35,
                    ),
                    Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
