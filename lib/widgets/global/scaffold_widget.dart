import 'dart:developer' as dev;
import 'dart:math';

import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/spinner_refresh_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/sliver_persisten_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class PageScaffold extends StatefulWidget {
  final Widget? childSliver;
  final Widget? child;
  final String title;
  final double? padding;
  final Widget? leading;
  final Widget? trailing;
  final bool scrollable;
  final bool? rounded;
  final Widget? header;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;
  const PageScaffold({
    Key? key,
    this.leading,
    this.trailing,
    this.onRefresh,
    this.padding,
    this.rounded,
    this.header,
    this.controller,
    this.child,
    this.childSliver,
    required this.scrollable,
    required this.title,
  }) : super(key: key);

  @override
  State<PageScaffold> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<PageScaffold> {
  @override
  Widget build(BuildContext context) {
    var slivers = SliverPadding(
      padding: EdgeInsets.all(widget.padding ?? 25),
      sliver: widget.childSliver ??
          (widget.scrollable
              ? SliverSafeArea(
                  top:
                      false, // Top safe area is consumed by the navigation bar.
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return widget.child;
                      },
                      childCount: 1,
                    ),
                  ),
                )
              : SliverFillRemaining(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: ThemesUtil.isAndroid(context) ? 25 : 100,
                    ),
                    child: widget.child,
                  ),
                )),
    );
    var page = CustomScrollView(
      physics: !widget.scrollable ? const NeverScrollableScrollPhysics() : null,
      controller: widget.controller,
      slivers: [
        slivers,
      ],
    );

    Scaffold scaffold = Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shape: widget.rounded != null && widget.rounded!
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              )
            : null,
        title: Text(
          widget.title,
          style: TextStyle(
            color: ThemesUtil.isAndroid(context)
                ? Theme.of(context).appBarTheme.titleTextStyle!.color
                : null,
          ),
        ),
        foregroundColor: Colors.white,
        leading: widget.leading,
        actions: [widget.trailing != null ? widget.trailing! : const Text("")],
      ),
      body: widget.onRefresh != null
          ? RefreshIndicator(
              onRefresh: widget.onRefresh!,
              color: Colors.greenAccent,
              child: page,
            )
          : page,
    );

    CupertinoPageScaffold cupertinoScaffold = CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: CustomScrollView(
        physics:
            !widget.scrollable ? const NeverScrollableScrollPhysics() : null,
        controller: widget.controller,
        slivers: [
          CupertinoSliverNavigationBar(
            //previousPageTitle: widget.previousPageTitle,
            border: null,
            stretch: false,
            backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
            leading: widget.leading,
            largeTitle: Text(widget.title),
            trailing: widget.trailing,
            brightness: CupertinoTheme.brightnessOf(context),
            transitionBetweenRoutes: false,
          ),
          if (widget.onRefresh != null && widget.childSliver == null)
            CupertinoSliverRefreshControl(
              onRefresh: widget.onRefresh!,
              builder: SpinnerRefreshUtil.buildSpinnerOnlyRefreshIndicator,
            ),
          if (widget.header != null)
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: 0,
                maxHeight: 75,
                child: widget.header!,
              ),
            ),
          //     : SliverSafeArea(
          //         top:
          //             false, // Top safe area is consumed by the navigation bar.
          //         sliver: SliverList(
          //           delegate: SliverChildBuilderDelegate(
          //             (BuildContext context, int index) {
          //               return Padding(
          //                 padding: EdgeInsets.all(widget.padding ?? 25),
          //                 child: widget.child,
          //               );
          //             },
          //             childCount: 1,
          //           ),
          //         ),
          //       ),
          slivers,
        ],
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? scaffold
        : cupertinoScaffold;
  }
}

class SimplePageScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final double? padding;
  final bool scrollable;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? isFullScreen;

  const SimplePageScaffold({
    Key? key,
    required this.body,
    this.title,
    this.padding,
    this.backgroundColor,
    this.titleColor,
    this.isFullScreen,
    required this.scrollable,
  }) : super(key: key);

  @override
  State<SimplePageScaffold> createState() => _SimpleScaffoldWidgetState();
}

class _SimpleScaffoldWidgetState extends State<SimplePageScaffold> {
  @override
  Widget build(BuildContext context) {
    bool isFullScreen = widget.isFullScreen ?? !widget.scrollable;

    var slivers = [
      isFullScreen
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.all(widget.padding ?? 25),
                  child: StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      !widget.scrollable
                          ? SizedBox(
                              height: ScreenUtil.getSize(context).height -
                                  (ScreenUtil.getSize(context).height / 8),
                              child: widget.body,
                            )
                          : widget.body,
                    ],
                  ),
                ),
                childCount: 1,
              ),
            )
          : SliverFillRemaining(
              child: Container(
                padding: EdgeInsets.all(widget.padding ?? 25),
                child: StaggeredGrid.count(
                  crossAxisCount: 1,
                  children: [
                    widget.body,
                  ],
                ),
              ),
            ),
    ];

    Scaffold scaffold = Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.title ?? "",
          style: TextStyle(
            color: widget.titleColor ?? Theme.of(context).primaryColorDark,
          ),
        ),
        backgroundColor:
            widget.backgroundColor ?? ThemesUtil.getPrimaryColor(context),
        elevation: 0,
        foregroundColor:
            widget.titleColor ?? Theme.of(context).primaryColorDark,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics:
              widget.scrollable ? null : const NeverScrollableScrollPhysics(),
          slivers: slivers,
        ),
      ),
    );

    CupertinoPageScaffold cupertinoScaffold = CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title ?? ""),
        border: null,
        backgroundColor: ThemesUtil.getBackgroundColor(context),
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics:
              widget.scrollable ? null : const NeverScrollableScrollPhysics(),
          slivers: slivers,
        ),
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? scaffold
        : cupertinoScaffold;
  }
}
