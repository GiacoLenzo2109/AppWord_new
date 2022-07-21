// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/alphabet_scroll_list.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/tab_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Book extends StatefulWidget {
  const Book({Key? key}) : super(key: key);

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    Tab(text: Constants.personalBook),
    Tab(text: Constants.classBook),
  ];

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "Rubrica",
      padding: 0,
      onRefresh: () async {},
      scrollable: false,
      leading: Theme.of(context).platform == TargetPlatform.android ? 
      GestureDetector(
        onTap: () {},
        child: const Icon(Icons.edit),
      ) :
      CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {},
        child: const Text("Modifica"),
      ),
      trailing: GestureDetector(
        child: const Icon(
          CupertinoIcons.add,
          size: 25,
        ),
        onTap: () {},
      ),
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        children: const [
          TabBarWidget(
            tabs: [Constants.personalBook, Constants.classBook],
            tabsView: [
              AlphabetScrollList(Constants.personalBook),
              AlphabetScrollList(Constants.classBook),
            ],
          ),
        ],
      ),
    );
  }
}
