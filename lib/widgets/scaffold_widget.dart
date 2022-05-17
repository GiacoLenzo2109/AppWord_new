import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatefulWidget {
  final Widget child;
  final Widget? appBar;
  final Widget? navigationBar;
  const PageScaffold(
      {Key? key, this.appBar, this.navigationBar, required this.child})
      : super(key: key);

  @override
  State<PageScaffold> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<PageScaffold> {
  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
      body: widget.child,
      bottomNavigationBar: widget.navigationBar != null
          ? widget.navigationBar as BottomNavigationBar
          : null,
    );

    CupertinoPageScaffold cupertinoScaffold = CupertinoPageScaffold(
      navigationBar: widget.appBar != null
          ? widget.appBar as CupertinoNavigationBar
          : null,
      child: widget.child,
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? scaffold
        : cupertinoScaffold;
  }
}
