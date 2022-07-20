import 'dart:developer';

import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TabBarWidget extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabsView;

  const TabBarWidget({
    Key? key,
    required this.tabs,
    required this.tabsView,
  }) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
            : CupertinoTheme.of(context).scaffoldBackgroundColor;

    //Android
    var tabBar = TabBar(
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
    );

    //iOS
    Map<int, Widget> _tabsMap = {};
    for (int i = 0; i < widget.tabs.length; i++) {
      _tabsMap.putIfAbsent(
        i,
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _tabs[i],
        ),
      );
    }
    var iTabBar = CupertinoSegmentedControl<int>(
      selectedColor: _selectedColor,
      unselectedColor: _unselectedColor,
      children: _tabsMap,
      groupValue: _tabController.index,
      onValueChanged: (tab) {
        setState(() {
          _tabController.index = tab;
        });
      },
    );

    var tabsView = SizedBox(
      height: ScreenUtil.getSize(context).height - 250,
      child: TabBarView(
        controller: _tabController,
        children: widget.tabsView,
      ),
    );

    return StaggeredGrid.count(
      crossAxisCount: 1,
      children: [
        Theme.of(context).platform == TargetPlatform.android ? tabBar : iTabBar,
        tabsView
      ],
    );
  }
}
