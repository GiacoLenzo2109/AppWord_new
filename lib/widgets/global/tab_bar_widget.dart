import 'dart:developer';

import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TabBarWidget extends StatefulWidget {
  final List<String> tabs;
  final List<Widget>? tabsView;
  final Function(int value) onValueChanged;
  final double? padding;
  final int? initialValue;

  const TabBarWidget({
    Key? key,
    required this.tabs,
    this.tabsView,
    this.padding,
    required this.onValueChanged,
    this.initialValue,
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
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.index = widget.initialValue ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    for (var tab in widget.tabs) {
      tabs.add(
        Theme.of(context).platform == TargetPlatform.android
            ? Padding(
                padding: Constants.padding,
                child: Text(
                  tab,
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              )
            : Text(
                tab,
                style: const TextStyle(fontSize: 15),
              ),
      );
    }

    final selectedColor = Theme.of(context).platform == TargetPlatform.android
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : CupertinoTheme.of(context).primaryColor;

    final unselectedColor = Theme.of(context).platform == TargetPlatform.android
        ? Theme.of(context).scaffoldBackgroundColor
        : CupertinoTheme.of(context).scaffoldBackgroundColor;

    //Android
    var tabBar = Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      child: TabBar(
        indicatorWeight: 3,
        splashBorderRadius: BorderRadius.circular(10),
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: MaterialDesignIndicator(
          indicatorHeight: 7.5,
          indicatorColor: ThemesUtil.isAndroid(context)
              ? ThemesUtil.getBackgroundColor(context)
              : Colors.transparent,
        ),
        tabs: tabs,
      ),
    );

    //iOS
    Map<int, Widget> tabsMap = {};
    for (int i = 0; i < widget.tabs.length; i++) {
      tabsMap.putIfAbsent(
        i,
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: tabs[i],
        ),
      );
    }
    var iTabBar = CupertinoSegmentedControl<int>(
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      children: tabsMap,
      groupValue: _tabController.index,
      padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 15),
      onValueChanged: (tab) {
        setState(() {
          _tabController.index = tab;
        });
      },
    );

    var tabsView = SizedBox(
      height: ScreenUtil.getSize(context).height - 150,
      child: TabBarView(
        controller: _tabController,
        children: widget.tabsView ?? [],
      ),
    );

    _tabController.addListener(() {
      widget.onValueChanged(_tabController.index);
    });

    return StaggeredGrid.count(
      crossAxisCount: 1,
      children: [
        Theme.of(context).platform == TargetPlatform.android ? tabBar : iTabBar,
        if (widget.tabsView != null) tabsView
      ],
    );
  }
}
