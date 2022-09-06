import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final Function(String) onChanged;
  final Function() onStop;

  const SearchTextField(
      {Key? key, required this.onChanged, required this.onStop})
      : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  var isTyping = false;
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Android
    var searchTextField = TextField(
      controller: controller,
      onChanged: (value) {
        widget.onChanged(value);
        isTyping = true;
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        filled: true,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        suffixIcon: isTyping
            ? GestureDetector(
                onTap: () {
                  widget.onStop();
                  isTyping = false;
                  controller.clear();
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Annulla",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : const SizedBox(),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemesUtil.getPrimaryColor(context),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: CupertinoColors.systemGrey4.withOpacity(.55),
        hintText: "Cerca",
        hintStyle: const TextStyle(color: Colors.white),
      ),
    );

    var iSearchTextField = CupertinoSearchTextField(
      placeholder: "Cerca",
      onChanged: widget.onChanged,
      padding: const EdgeInsets.all(0),
      prefixInsets: const EdgeInsets.symmetric(horizontal: 7.5),
      backgroundColor: CupertinoColors.systemGrey4,
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? searchTextField
        : iSearchTextField;
  }
}
