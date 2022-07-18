import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatefulWidget {
  final Widget child;
  final Widget? navigationBar;
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final bool scrollable;
  const PageScaffold(
      {Key? key,
      this.navigationBar,
      this.leading,
      this.trailing,
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
    Scaffold scaffold = Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        leading: widget.leading,
        actions: [widget.trailing != null ? widget.trailing! : const Text("")],
      ),
      body: widget.scrollable
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: widget.child,
              ))
          : Padding(
              padding: const EdgeInsets.all(25),
              child: widget.child,
            ),
    );

    CupertinoPageScaffold cupertinoScaffold = CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            border: null,
            backgroundColor: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.5),
            leading: widget.leading,
            largeTitle: Text(widget.title),
            trailing: widget.trailing,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  widget.child,
                  const SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? scaffold
        : cupertinoScaffold;
  }
}
