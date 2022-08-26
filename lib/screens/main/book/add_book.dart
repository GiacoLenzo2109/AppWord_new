import 'dart:developer';

import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/providers/book_list_model.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/container_widget.dart';
import 'package:app_word/widgets/global/pin_text_field.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  var nameController = TextEditingController();
  var pinController = TextEditingController();
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    final bookListProvider = Provider.of<BookListProvider>(context);
    return PageScaffold(
      scrollable: false,
      title: "Crea rubrica",
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 25,
        children: [
          ContainerWidget(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: [
                Text(
                  "Nome:",
                  style: ThemesUtil.titleContainerStyle(context),
                ),
                TextFieldWidget(
                  placeholder: "Nome",
                  icon: CupertinoIcons.doc,
                  controller: nameController,
                ),
              ],
            ),
          ),
          ContainerWidget(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: [
                Text(
                  "Pin:",
                  style: ThemesUtil.titleContainerStyle(context),
                ),
                PinCodeTextField(
                  autofocus: false,
                  controller: pinController,
                  hideCharacter: false,
                  highlight: true,
                  highlightColor: CupertinoColors.activeBlue,
                  defaultBorderColor:
                      CupertinoColors.systemGrey.withOpacity(.5),
                  hasTextBorderColor: CupertinoColors.activeGreen,
                  maxLength: 6,
                  pinBoxWidth: ScreenUtil.getSize(context).width / 9,
                  pinBoxHeight: ScreenUtil.getSize(context).width / 9,
                  hasError: hasError,
                  onTextChanged: (text) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  //maskCharacter: Constants.emojis[randomN],
                  isCupertino: true,
                  // onDone: (pin) async {
                  //   await BookRepository.addBook(
                  //     context: context,
                  //     boo: pin,
                  //   ).then((book) {
                  //     book == null ? hasError = true : widget.onFinish(book);
                  //   });
                  // },
                  wrapAlignment: WrapAlignment.center,
                  pinBoxDecoration: (borderColor, pinBoxColor,
                          {borderWidth = 10, radius = 10}) =>
                      BoxDecoration(
                    border: Border.all(color: borderColor, width: borderWidth),
                    borderRadius: BorderRadius.circular(10),
                    color: ThemesUtil.getBackgroundColor(context),
                  ),
                  pinTextStyle: const TextStyle(fontSize: 20.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration:
                      const Duration(milliseconds: 150),
                  highlightAnimation: false,
                  highlightAnimationBeginColor: CupertinoColors.systemGrey3,
                  highlightAnimationEndColor: Colors.transparent,
                ),
              ],
            ),
          ),
          ButtonWidget(
            text: "Crea",
            onPressed: () async {
              Book book = Book(
                name: nameController.text,
                pin: pinController.text,
                members: [],
              );
              if (book.name.isEmpty) {
                DialogUtil.openDialog(
                  context: context,
                  builder: (context) =>
                      const ErrorDialogWidget("Nome non valido!"),
                );
              } else if (book.pin.length < 4) {
                DialogUtil.openDialog(
                  context: context,
                  builder: (context) =>
                      const ErrorDialogWidget("Nome non valido!"),
                );
              } else {
                var bookCheck = await BookRepository.getBook(
                    context: context, pin: pinController.text);

                if (bookCheck == null) {
                  await BookRepository.addBook(context: context, book: book)
                      .then((book) => {
                            bookListProvider.addBook(book),
                          });
                } else {
                  setState(() {
                    hasError = true;
                  });
                  DialogUtil.openDialog(
                    context: context,
                    builder: (context) =>
                        const ErrorDialogWidget("Pin già in uso!"),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
