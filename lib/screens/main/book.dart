// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/alphabet_scroll_list.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:app_word/widgets/scaffold_widget.dart';
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

  var _selectedTab = 0;

  final _tabs = const [
    Tab(text: Constants.personalBook),
    Tab(text: Constants.classBook),
  ];

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTab = _tabController.index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _selectedColor = Theme.of(context).platform == TargetPlatform.android
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : CupertinoTheme.of(context).primaryColor;

    final _unselectedColor =
        Theme.of(context).platform == TargetPlatform.android
            ? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor
            : CupertinoTheme.of(context).primaryContrastingColor;

    return PageScaffold(
      title: "Rubrica",
      scrollable: false,
      child: Column(
        children: [
          TabBar(
            indicatorWeight: 0,
            splashBorderRadius: BorderRadius.circular(10),
            controller: _tabController,
            labelColor: _unselectedColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: _unselectedColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: MaterialDesignIndicator(
                indicatorHeight: 4, indicatorColor: _selectedColor!),
            tabs: _tabs,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AlphabetScrollList("P"),
                AlphabetScrollList("C"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
