import 'package:app_word/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Book extends StatelessWidget {
  const Book({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.bookPage),
      ),
    );
  }
}
