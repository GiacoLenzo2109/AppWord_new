import 'dart:developer';
import 'dart:html';

import 'package:app_word/util/constants.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabBarWidget extends StatefulWidget {
  final List<String> tabs;
  final TickerProvider? syncObj;
  final TabController tabController;

  const TabBarWidget(
      {Key? key, this.syncObj, required this.tabController, required this.tabs})
      : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _tabs = [];
    for (var tab in widget.tabs) {
      _tabs.add(Text(tab));
    }

    final _selectedColor = Theme.of(context).platform == TargetPlatform.android
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : CupertinoTheme.of(context).primaryColor;

    final _unselectedColor =
        Theme.of(context).platform == TargetPlatform.android
            ? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor
            : CupertinoTheme.of(context).primaryContrastingColor;
    //Android
    var tabBar = TabBar(
      indicatorWeight: 0,
      splashBorderRadius: BorderRadius.circular(10),
      controller: widget.tabController,
      labelColor: _unselectedColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelColor: _unselectedColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: MaterialDesignIndicator(
          indicatorHeight: 4, indicatorColor: _selectedColor!),
      tabs: _tabs,
    );

    //iOS
    var selectedIndex = widget.tabs[0];
    Map<String, Widget> _tabsMap = {};
    for (int i = 0; i < widget.tabs.length; i++) {
      _tabsMap.putIfAbsent(
        widget.tabs[i],
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _tabs[i],
        ),
      );
    }
    var iTabBar = CupertinoSegmentedControl<String>(
      selectedColor: _selectedColor,
      unselectedColor: _unselectedColor,
      children: _tabsMap,
      groupValue: selectedIndex,
      onValueChanged: (String tab) {
        setState(() {
          log(tab);
          selectedIndex = tab;
        });
      },
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? tabBar
        : iTabBar;
  }
}
