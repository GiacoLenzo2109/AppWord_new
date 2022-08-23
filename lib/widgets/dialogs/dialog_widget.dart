// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/user_repository.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/global_func.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
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
  static const USERNAME = "USERNAME";
  static const EMAIL = "EMAIL";
  static const PASSWORD = "PASSWORD";

  Function()? onPressed;
  String? msg;
  String? title;
  String? type;
  DialogType? dType;
  Widget? body;
  String? doneText;
  Color? doneColorText;

  DialogWidget({
    Key? key,
    this.type,
    this.onPressed,
    this.title,
    this.msg,
    this.dType,
    this.body,
    this.doneText,
    this.doneColorText,
  }) : super(key: key);

  DialogWidget.username({
    this.type,
    Key? key,
  }) : super(key: key) {
    type = USERNAME;
    dType = DialogType.WARNING;
  }

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

  String text = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    var title = Text(
      widget.title ??
          (widget.type == DialogWidget.EMAIL
              ? "Cambia email"
              : widget.type == DialogWidget.PASSWORD
                  ? "Cambia password"
                  : "Cambia username"),
    );

    Future<void> onPressedDone() async {
      switch (widget.type) {
        case (DialogWidget.EMAIL):
          if (GlobalFunc.isEmail(text)) {
            LoadingWidget.show(context);
            await FirebaseGlobal.auth.currentUser!.updateEmail(text);
          } else {
            DialogUtil.openDialog(
                context: context,
                builder: (context) =>
                    const ErrorDialogWidget("Email non valida"));
          }
          break;
        case (DialogWidget.PASSWORD):
          if (text.isNotEmpty && text == confirmPassword) {
            LoadingWidget.show(context);
            await FirebaseGlobal.auth.currentUser!.updatePassword(text);
          } else {
            DialogUtil.openDialog(
                context: context,
                builder: (context) =>
                    const ErrorDialogWidget("Le password non combaciano!"));
          }
          break;
        case (DialogWidget.USERNAME):
          if (text.isNotEmpty) {
            LoadingWidget.show(context);
            await FirebaseGlobal.auth.currentUser!.updateDisplayName(text);
          } else {
            DialogUtil.openDialog(
                context: context,
                builder: (context) =>
                    const ErrorDialogWidget("Username non valido"));
          }
          break;
      }
      await UserRepository.updateUser(
          context: context, user: FirebaseGlobal.auth.currentUser!);

      Navigator.of(context).pop();
    }

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
      btnOkOnPress: widget.onPressed ?? onPressedDone,
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
                  title,
                  Text(widget.msg ?? ''),
                  if (widget.type != null)
                    TextFieldWidget(
                      onChanged: (t) {
                        setState(() {
                          text = t;
                        });
                      },
                      placeholder: widget.type == DialogWidget.EMAIL
                          ? FirebaseGlobal.auth.currentUser != null
                              ? FirebaseGlobal.auth.currentUser!.email
                              : "esempio@gmail.com"
                          : widget.type == DialogWidget.USERNAME
                              ? FirebaseGlobal.auth.currentUser != null
                                  ? FirebaseGlobal.auth.currentUser!.displayName
                                  : "Username"
                              : "Nuova password",
                      icon: widget.type == DialogWidget.EMAIL
                          ? CupertinoIcons.mail
                          : widget.type == DialogWidget.USERNAME
                              ? CupertinoIcons.person
                              : CupertinoIcons.lock,
                      isPassword: widget.type == DialogWidget.PASSWORD,
                      type: widget.type == DialogWidget.EMAIL
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                    ),
                  if (widget.type == DialogWidget.PASSWORD)
                    TextFieldWidget(
                      onChanged: (t) {
                        setState(() {
                          confirmPassword = t;
                        });
                      },
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
      title: title,
      content: widget.body ??
          SizedBox(
            child: widget.type != null
                ? StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      const SizedBox(height: 15),
                      TextFieldWidget(
                        onChanged: (t) {
                          setState(() {
                            text = t;
                          });
                        },
                        placeholder: widget.type == DialogWidget.EMAIL
                            ? FirebaseGlobal.auth.currentUser != null
                                ? FirebaseGlobal.auth.currentUser!.email
                                : "esempio@gmail.com"
                            : widget.type == DialogWidget.USERNAME
                                ? FirebaseGlobal.auth.currentUser != null
                                    ? FirebaseGlobal
                                        .auth.currentUser!.displayName
                                    : "Username"
                                : "Nuova password",
                        icon: widget.type == DialogWidget.EMAIL
                            ? CupertinoIcons.mail
                            : widget.type == DialogWidget.USERNAME
                                ? CupertinoIcons.person
                                : CupertinoIcons.lock,
                        isPassword: widget.type == DialogWidget.PASSWORD,
                        type: widget.type == DialogWidget.EMAIL
                            ? TextInputType.emailAddress
                            : TextInputType.text,
                      ),
                      const SizedBox(height: 15),
                      if (widget.type == DialogWidget.PASSWORD)
                        TextFieldWidget(
                          onChanged: (t) {
                            setState(() {
                              confirmPassword = t;
                            });
                          },
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
          onPressed: () async {
            if (widget.onPressed != null) {
              widget.onPressed!();
            }
            if (widget.type != null) {
              await onPressedDone();
            }
            Navigator.of(context).pop();
          },
          child: Text(
            widget.doneText ?? 'Fatto',
            style: TextStyle(color: widget.doneColorText),
          ),
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
