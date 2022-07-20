import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatefulWidget {
  final Widget child;
  final Widget? navigationBar;
  final String title;
  final double? padding;
  final Widget? leading;
  final Widget? trailing;
  final bool scrollable;
  final Future<void> Function()? onRefresh;
  const PageScaffold(
      {Key? key,
      this.navigationBar,
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
      padding: const EdgeInsets.all(25),
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
                backgroundColor: Colors.greenAccent,
                child: widget.scrollable ? scrollView : page)
            : widget.scrollable
                ? scrollView
                : page);

    CupertinoPageScaffold cupertinoScaffold = CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
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
          if (widget.onRefresh != null)
            CupertinoSliverRefreshControl(
              onRefresh: widget.onRefresh,
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
