import 'package:app_word/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/global/scaffold_widget.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
        title: "Cerca", scrollable: false, child: Text("Cerca"));
  }
}
