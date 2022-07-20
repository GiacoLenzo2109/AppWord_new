import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final Function(String) onChanged;

  const SearchTextField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Android
    var searchTextField = TextField(
      onChanged: onChanged,
    );

    var iSearchTextField = CupertinoSearchTextField(
      onChanged: onChanged,
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? searchTextField
        : iSearchTextField;
  }
}
