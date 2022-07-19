// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/alphabet_scroll_list.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:app_word/widgets/scaffold_widget.dart';
import 'package:app_word/widgets/tab_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "Rubrica",
      onRefresh: () async {},
      scrollable: false,
      child: Column(
        children: [
          TabBarWidget(
            tabs: const [Constants.personalBook, Constants.classBook],
            syncObj: this,
            tabController: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AlphabetScrollList(Constants.personalBook),
                AlphabetScrollList(Constants.classBook),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
