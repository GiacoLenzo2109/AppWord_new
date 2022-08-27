import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class JoinBookPage extends StatefulWidget {
  final TextEditingController pinController;
  final Function(Book) onFinish;
  const JoinBookPage({
    Key? key,
    required this.pinController,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<JoinBookPage> createState() => _JoinBookPageState();
}

class _JoinBookPageState extends State<JoinBookPage> {
  bool hasError = false;
  int randomN = math.Random().nextInt(Constants.emojis.length);
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    widget.pinController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      scrollable: false,
      title: "Inserisci pin",
      //scrollable: false,
      body: SizedBox(
        height: ScreenUtil.getSize(context).height,
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          children: [
            const Text(
              "Inserisci il codice segreto per accedere alla rubrica!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const Text(
              Constants.shhhEmoji,
              style: TextStyle(fontSize: 75),
              textAlign: TextAlign.center,
            ),
            // const Icon(
            //   CupertinoIcons.eye_slash_fill,
            //   size: 75,
            //   color: CupertinoColors.systemGrey,
            // ),
            Center(
              child: PinCodeTextField(
                focusNode: focusNode,
                autofocus: true,
                controller: widget.pinController,
                hideCharacter: true,
                highlight: true,
                hasUnderline: false,
                highlightColor: CupertinoColors.activeBlue,
                defaultBorderColor: CupertinoColors.systemGrey.withOpacity(.5),
                hasTextBorderColor: CupertinoColors.activeGreen,
                maxLength: 6,
                pinBoxWidth: ScreenUtil.getSize(context).width / 8,
                pinBoxHeight: ScreenUtil.getSize(context).width / 8,
                hasError: hasError,
                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                  });
                },
                maskCharacter: Constants.emojis[randomN],
                isCupertino: true,
                onDone: (pin) async {
                  await BookRepository.joinBook(
                    context: context,
                    pin: pin,
                  ).then((book) {
                    book == null ? hasError = true : widget.onFinish(book);
                  });
                },
                wrapAlignment: WrapAlignment.center,
                pinBoxDecoration: (borderColor, pinBoxColor,
                        {borderWidth = 10, radius = 10}) =>
                    BoxDecoration(
                  border: Border.all(color: borderColor, width: borderWidth),
                  borderRadius: BorderRadius.circular(10),
                  color: ThemesUtil.getBackgroundColor(context),
                ),
                pinTextStyle: const TextStyle(fontSize: 25.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration:
                    const Duration(milliseconds: 150),
                highlightAnimation: false,
                highlightAnimationBeginColor: CupertinoColors.activeBlue,
                highlightAnimationEndColor:
                    CupertinoColors.systemGrey.withOpacity(.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
