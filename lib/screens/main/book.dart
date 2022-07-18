import 'package:app_word/util/constants.dart';
import 'package:app_word/widgets/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Book extends StatelessWidget {
  const Book({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(title: "Rubrica", child: Text("Rubrica"));
  }
}
