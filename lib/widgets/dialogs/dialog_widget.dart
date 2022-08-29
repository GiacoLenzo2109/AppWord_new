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
import 'package:app_word/widgets/global/container_widget.dart';
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
  bool? autoPop;
  IconData? doneIcon;

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
    this.doneIcon,
    bool? autoPop,
  }) : super(key: key) {
    this.autoPop = autoPop ?? true;
  }

  // DialogWidget.username({
  //   this.type,
  //   Key? key,
  // }) : super(key: key) {
  //   type = USERNAME;
  //   dType = DialogType.WARNING;
  // }

  // DialogWidget.email({
  //   this.type,
  //   Key? key,
  // }) : super(key: key) {
  //   type = EMAIL;
  //   dType = DialogType.WARNING;
  // }

  // DialogWidget.password({
  //   this.type,
  //   Key? key,
  // }) : super(key: key) {
  //   type = PASSWORD;
  //   dType = DialogType.WARNING;
  // }

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  bool onPressed = false;

  String text = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    var title = Padding(
      padding: Constants.padding,
      child: Text(widget.title ?? ""
          //     (widget.type == DialogWidget.EMAIL
          //         ? "Cambia email"
          //         : widget.type == DialogWidget.PASSWORD
          //             ? "Cambia password"
          //             : "Cambia username"),
          ),
    );

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
      btnOkText: widget.doneText,
      btnOkColor: widget.doneColorText,
      btnOkOnPress: widget.onPressed,
      btnOkIcon: widget.doneIcon ?? Icons.done,
      onDissmissCallback: (type) => Navigator.of(context).pop(),
      title: widget.title,
      desc: widget.msg,
      body: widget.body != null
          ? StaggeredGrid.count(
              crossAxisCount: 1,
              children: [
                if (widget.body != null && widget.title != null)
                  Text(
                    widget.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                widget.body!,
              ],
            )
          : null,
    );

    //CupertinoDialog
    CupertinoAlertDialog iDialog = CupertinoAlertDialog(
      title: title,
      content: widget.body ?? Text(widget.msg ?? ''),
      actions: [
        CupertinoButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancella'),
        ),
        CupertinoButton(
          onPressed: () => {
            if (widget.onPressed != null)
              {
                widget.onPressed!(),
              },
            if (widget.autoPop!)
              {
                Navigator.of(context).pop(),
              }
          },
          child: Text(
            widget.doneText ?? 'Fatto',
            style: TextStyle(color: widget.doneColorText),
          ),
        ),
      ],
    );

    if (Theme.of(context).platform == TargetPlatform.android &&
        !onPressed &&
        widget.body == null) {
      Future.delayed(const Duration(seconds: 0), () {
        setState(() {
          onPressed = true;
        });
        dialog.show();
      });
    }

    // Future.delayed(const Duration(seconds: 0), () {
    //   if (ThemesUtil.isAndroid(context)) dialog.show();
    // });

    Widget dialogWithBody = SizedBox(
      height: ScreenUtil.getSize(context).height,
      width: ScreenUtil.getSize(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisCount: 1,
        children: [
          if (widget.body != null && widget.title != null)
            ContainerWidget(
              margin: 25,
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                children: [
                  Text(
                    widget.title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: ThemesUtil.getTextColor(context),
                    ),
                  ),
                  widget.body!,
                ],
              ),
            ),
        ],
      ),
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? iDialog
        : dialogWithBody;
  }
}
