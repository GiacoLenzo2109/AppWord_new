import 'package:app_word/util/constants.dart';
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
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        filled: true,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isTyping
            ? GestureDetector(
                onTap: () {
                  widget.onStop();
                  isTyping = false;
                  controller.clear();
                },
                child: const Padding(
                    padding: Constants.padding, child: Text("Annulla")),
              )
            : const SizedBox(),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: "Cerca",
      ),
    );

    var iSearchTextField = CupertinoSearchTextField(
      placeholder: "Cerca",
      onChanged: widget.onChanged,
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? searchTextField
        : iSearchTextField;
  }
}
