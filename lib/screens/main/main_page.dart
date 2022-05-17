import 'package:app_word/screens/main/book.dart';
import 'package:app_word/screens/main/home.dart';
import 'package:app_word/screens/main/search.dart';
import 'package:app_word/screens/main/settings.dart';
import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _page = 0;
  var pages = const [Home(), Book(), Search(), Settings()];
  @override
  Widget build(BuildContext context) {
    Scaffold materialScaffold = Scaffold(
      body: Padding(
        padding: Constants.padding,
        child: IndexedStack(
          index: _page,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: Constants.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: Constants.bookPage,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: Constants.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: Constants.settings,
          ),
        ],
        currentIndex: _page,
        onTap: (index) => {
          setState(() => _page = index),
        },
      ),
    );
    CupertinoTabScaffold cupertinoPageScaffold = CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoTheme.of(context)
            .scaffoldBackgroundColor
            .withOpacity(0.75),
        border: null,
        activeColor: CupertinoColors.activeBlue,
        currentIndex: _page,
        onTap: (index) {
          _page = index;
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: Constants.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: Constants.bookPage,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: Constants.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: Constants.settings,
          ),
        ],
      ),
      tabBuilder: (_, index) => CupertinoTabView(
        builder: (context) {
          return CupertinoPageScaffold(
            child: Padding(
              padding: Constants.padding,
              child: IndexedStack(
                index: index,
                children: pages,
              ),
            ),
          );
        },
      ),
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? cupertinoPageScaffold
        : materialScaffold;
  }
}
