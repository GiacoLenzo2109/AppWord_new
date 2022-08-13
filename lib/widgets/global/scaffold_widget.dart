import 'dart:math';

import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  final double? padding;
  final Widget? leading;
  final Widget? trailing;
  final bool scrollable;
  final Future<void> Function()? onRefresh;
  const PageScaffold(
      {Key? key,
      this.leading,
      this.trailing,
      this.onRefresh,
      this.padding,
      required this.scrollable,
      required this.title,
      required this.child})
      : super(key: key);

  @override
  State<PageScaffold> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<PageScaffold> {
  @override
  Widget build(BuildContext context) {
    var page = Padding(
      padding: EdgeInsets.all(widget.padding ?? 25),
      child: widget.child,
    );
    var scrollView = SingleChildScrollView(
        physics: const BouncingScrollPhysics(), child: page);

    Scaffold scaffold = Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            widget.title,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          leading: widget.leading,
          actions: [
            widget.trailing != null ? widget.trailing! : const Text("")
          ],
        ),
        body: widget.onRefresh != null
            ? RefreshIndicator(
                onRefresh: widget.onRefresh!,
                color: Colors.greenAccent,
                child: widget.scrollable ? scrollView : page)
            : widget.scrollable
                ? scrollView
                : page);

    Widget _buildSpinnerOnlyRefreshIndicator(
        BuildContext context,
        RefreshIndicatorMode refreshState,
        double pulledExtent,
        double refreshTriggerPullDistance,
        double refreshIndicatorExtent) {
      const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Opacity(
            opacity: opacityCurve
                .transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
            child: const CupertinoActivityIndicator(radius: 14.0),
          ),
        ),
      );
    }

    CupertinoPageScaffold cupertinoScaffold = CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          if (widget.onRefresh != null)
            CupertinoSliverRefreshControl(
              onRefresh: widget.onRefresh,
              builder: _buildSpinnerOnlyRefreshIndicator,
            ),
          CupertinoSliverNavigationBar(
            border: null,
            stretch: true,
            backgroundColor: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.5),
            leading: widget.leading,
            largeTitle: Text(widget.title),
            trailing: widget.trailing,
          ),
          SliverFillRemaining(
            hasScrollBody: widget.scrollable,
            child: Padding(
              padding: EdgeInsets.all(widget.padding ?? 25),
              child: widget.child,
            ),
          ),
        ],
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? scaffold
        : cupertinoScaffold;
  }
}
