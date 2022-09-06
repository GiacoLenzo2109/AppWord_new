import 'dart:developer';

import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/icon_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFieldWidget extends StatefulWidget {
  final String? placeholder;
  final int? maxLines;
  final IconData? icon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? text;
  final FocusNode? focusNode;
  final double? padding;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool? isPassword;
  final TextInputType? type;
  final bool? expands;

  const TextFieldWidget({
    Key? key,
    this.placeholder,
    this.icon,
    this.maxLines,
    this.onChanged,
    this.focusNode,
    this.padding,
    this.controller,
    this.onSubmitted,
    this.textInputAction,
    this.text,
    this.isPassword,
    this.type,
    this.expands,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool obscure;
  late bool isPassword;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    isPassword = widget.isPassword ?? false;
    obscure = widget.isPassword ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text != null) {
      controller.text = widget.text!;
    }
    TextField textField = TextField(
      textAlign: widget.type == TextInputType.number
          ? TextAlign.center
          : TextAlign.start,
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.all(0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).backgroundColor,
            width: 3,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: CupertinoColors.placeholderText,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemesUtil.getPrimaryColor(context),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: CupertinoColors.systemGrey,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  !obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                ),
                splashRadius: 20,
                onPressed: () => setState(() {
                  obscure = !obscure;
                }),
              )
            : const SizedBox(),
        hintText: widget.text ?? widget.placeholder,
      ),
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      controller: widget.controller,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      maxLines: widget.expands != null && widget.expands!
          ? null
          : obscure
              ? 1
              : widget.maxLines ?? 1,
      expands:
          widget.expands ?? widget.maxLines != null && widget.maxLines! > 1,
      obscureText: obscure,
      keyboardType: widget.type,
    );

    CupertinoTextField iTextField = CupertinoTextField(
      textAlign: widget.type == TextInputType.number
          ? TextAlign.center
          : TextAlign.start,
      placeholder: widget.text ?? widget.placeholder,
      prefix: widget.icon != null
          ? Padding(
              padding: Constants.padding,
              child: Icon(
                widget.icon,
                size: 20,
              ),
            )
          : null,
      decoration: BoxDecoration(
        color: CupertinoThemes.backgroundColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: .25),
      ),
      padding: EdgeInsets.all(widget.padding ?? 10),
      maxLines: widget.expands != null && widget.expands!
          ? null
          : obscure
              ? 1
              : widget.maxLines ?? 1,
      expands:
          widget.expands ?? widget.maxLines != null && widget.maxLines! > 1,
      onChanged: widget.onChanged,
      controller: widget.controller ?? controller,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      obscureText: obscure,
      keyboardType: widget.type,
      suffix: isPassword
          ? IconButtonWidget(
              icon: Icon(
                !obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              })
          : Container(),
    );

    return !ThemesUtil.isAndroid(context) ? iTextField : textField;
  }
}
