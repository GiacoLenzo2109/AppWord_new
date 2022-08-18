import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/icon_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFieldWidget extends StatefulWidget {
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
  bool isPassword = false;
  TextInputType? type;

  TextFieldWidget({
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
    bool? isPassword,
    TextInputType? type,
  }) : super(key: key) {
    this.isPassword = isPassword ?? false;
    this.type = type;
  }

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool obscure;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    obscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text != null) {
      controller.text = widget.text!;
    }
    TextField textField = TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).backgroundColor,
            width: 3,
          ),
        ),
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: const Icon(CupertinoIcons.eye),
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
      maxLines: obscure ? 1 : widget.maxLines ?? 1,
      expands: widget.maxLines != null && widget.maxLines! > 1,
      obscureText: obscure,
      keyboardType: widget.type,
    );

    CupertinoTextField iTextField = CupertinoTextField(
      placeholder: widget.text ?? widget.placeholder,
      prefix: Padding(
        padding: Constants.padding,
        child: Icon(
          widget.icon,
          size: 20,
        ),
      ),
      decoration: BoxDecoration(
        color: CupertinoThemes.backgroundColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: .25),
      ),
      padding: EdgeInsets.all(widget.padding ?? 0),
      maxLines: obscure ? 1 : widget.maxLines ?? 1,
      expands: widget.maxLines != null && widget.maxLines! > 1,
      onChanged: widget.onChanged,
      controller: widget.controller ?? controller,
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      obscureText: obscure,
      keyboardType: widget.type,
      suffix: widget.isPassword
          ? IconButtonWidget(
              icon: const Icon(CupertinoIcons.eye),
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              })
          : Container(),
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? iTextField
        : textField;
  }
}
