import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFieldWidget extends StatelessWidget {
  String? placeholder;
  int? maxLines;
  IconData? icon;
  Function(String)? onChanged;
  Function(String)? onSubmitted;
  String? text;
  FocusNode? focusNode;
  double? padding;
  TextEditingController? controller;
  TextInputAction? textInputAction;

  TextFieldWidget(
      {Key? key,
      this.placeholder,
      this.icon,
      this.maxLines,
      this.onChanged,
      this.focusNode,
      this.padding,
      this.controller,
      this.onSubmitted,
      this.textInputAction,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextField textField = TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: text ?? placeholder,
      ),
      onChanged: onChanged,
      expands: maxLines == null ? true : false,
      focusNode: focusNode,
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
    );

    CupertinoTextField iTextField = CupertinoTextField(
      placeholder: text ?? placeholder,
      prefix: Padding(
        padding: Constants.padding,
        child: Icon(
          icon,
          size: 20,
        ),
      ),
      padding: EdgeInsets.all(padding ?? 5),
      maxLines: maxLines,
      expands: maxLines == null ? true : false,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? iTextField
        : textField;
  }
}
