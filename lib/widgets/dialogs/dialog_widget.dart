// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

// ignore: must_be_immutable
class DialogWidget extends StatefulWidget {
  static const EMAIL = "EMAIL";
  static const PASSWORD = "PASSWORD";

  Function()? onPressed;
  String? msg;
  String? title;
  String? type;
  DialogType? dType;
  Widget? body;

  DialogWidget({
    Key? key,
    this.type,
    this.onPressed,
    this.title,
    this.msg,
    this.dType,
    this.body,
  }) : super(key: key);

  DialogWidget.email({
    this.type,
    Key? key,
  }) : super(key: key) {
    type = EMAIL;
    dType = DialogType.WARNING;
  }

  DialogWidget.password({
    this.type,
    Key? key,
  }) : super(key: key) {
    type = PASSWORD;
    dType = DialogType.WARNING;
  }

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  bool onPressed = false;

  String email = "";
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    //Material Dialog
    var dialog = AwesomeDialog(
      context: context,
      padding: Constants.padding,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      showCloseIcon: true,
      dialogType: widget.dType ?? DialogType.NO_HEADER,
      buttonsBorderRadius: BorderRadius.circular(10),
      //btnCancelOnPress: () => Navigator.of(context).pop(),
      btnCancelIcon: Icons.cancel_outlined,
      btnOkOnPress: widget.onPressed ??
          () {
            widget.type == DialogWidget.EMAIL
                ? () {/*UPDATE EMAIL*/}
                : () {/*UPDATE PASSWORD*/};
          },
      btnOkIcon: Icons.done,
      onDissmissCallback: (type) => Navigator.of(context).pop(),
      body: StaggeredGrid.count(
        crossAxisCount: 1,
        children: [
          if (widget.body != null && widget.title != null)
            Text(
              widget.title!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          widget.body ??
              StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                children: [
                  Text(
                    widget.title ??
                        (widget.type == DialogWidget.EMAIL
                            ? "Cambia email"
                            : "Cambia password"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  Text(widget.msg ?? ''),
                  if (widget.type != null)
                    TextFieldWidget(
                      onChanged: (t) => widget.type == DialogWidget.EMAIL
                          ? email = t
                          : password = t,
                      placeholder: widget.type == DialogWidget.EMAIL
                          ? "esempio@gmail.com"
                          : "Nuova password",
                      icon: widget.type == DialogWidget.EMAIL
                          ? CupertinoIcons.mail
                          : CupertinoIcons.lock,
                      isPassword: widget.type == DialogWidget.PASSWORD,
                      type: widget.type == DialogWidget.EMAIL
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                    ),
                  if (widget.type == DialogWidget.PASSWORD)
                    TextFieldWidget(
                      onChanged: (t) => confirmPassword = t,
                      placeholder: "Conferma password",
                      icon: CupertinoIcons.lock,
                      isPassword: true,
                    ),
                ],
              ),
        ],
      ),
    );

    //CupertinoDialog
    CupertinoAlertDialog iDialog = CupertinoAlertDialog(
      title: Text(
        widget.title ??
            (widget.type == DialogWidget.EMAIL
                ? "Cambia email"
                : widget.type == DialogWidget.PASSWORD
                    ? "Cambia password"
                    : ""),
      ),
      content: widget.body ??
          SizedBox(
            child: widget.type != null
                ? StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      const SizedBox(height: 15),
                      TextFieldWidget(
                        placeholder: widget.type == DialogWidget.EMAIL
                            ? "esempio@gmail.com"
                            : "Nuova password",
                        icon: widget.type == DialogWidget.EMAIL
                            ? CupertinoIcons.mail
                            : CupertinoIcons.lock,
                        isPassword: widget.type == DialogWidget.PASSWORD,
                        type: widget.type == DialogWidget.EMAIL
                            ? TextInputType.emailAddress
                            : TextInputType.text,
                      ),
                      const SizedBox(height: 15),
                      if (widget.type == DialogWidget.PASSWORD)
                        TextFieldWidget(
                          placeholder: "Conferma password",
                          icon: CupertinoIcons.lock,
                          isPassword: true,
                        ),
                    ],
                  )
                : Text(widget.msg ?? ''),
          ),
      actions: [
        CupertinoButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancella'),
        ),
        CupertinoButton(
          onPressed: widget.onPressed != null
              ? () {
                  widget.onPressed;
                  Navigator.of(context).pop();
                }
              : () {
                  widget.type == DialogWidget.EMAIL
                      ? () {/*UPDATE EMAIL*/}
                      : () {/*UPDATE PASSWORD*/};
                },
          child: const Text('Fatto'),
        ),
      ],
    );

    if (widget.onPressed == null &&
        Theme.of(context).platform == TargetPlatform.android &&
        !onPressed) {
      Future.delayed(const Duration(seconds: 0)).then((value) {
        setState(() {
          onPressed = true;
        });
        dialog.show();
      });
    }

    return Theme.of(context).platform == TargetPlatform.iOS
        ? iDialog
        : Container();
  }
}
