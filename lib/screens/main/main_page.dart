import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/providers/theme_provider.dart';
import 'package:app_word/screens/main/book.dart';
import 'package:app_word/screens/main/home.dart';
import 'package:app_word/screens/main/settings.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _page = 0;
  List<Widget> _buildScreens() => [
        ChangeNotifierProvider(
          create: (context) => NavbarModel(),
          builder: (context, child) => const Home(),
        ),
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavbarModel(),
            ),
            ChangeNotifierProvider(
              create: (context) => BookModel(),
            ),
          ],
          builder: (context, child) => const Book(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => NavbarModel(),
        //   builder: (context, child) => const Search(),
        // ),
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavbarModel(),
            ),
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
            ),
          ],
          builder: (context, child) => const Settings(),
        ),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    bool isAndroid =
        Theme.of(context).platform == TargetPlatform.android ? true : false;
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: "Home",
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: isAndroid
            ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
            : CupertinoTheme.of(context).primaryColor,
        inactiveColorPrimary: isAndroid
            ? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!
            : CupertinoTheme.of(context).primaryContrastingColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.book),
        title: "Rubrica",
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: isAndroid
            ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
            : CupertinoTheme.of(context).primaryColor,
        inactiveColorPrimary: isAndroid
            ? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!
            : CupertinoTheme.of(context).primaryContrastingColor,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.search_rounded),
      //   title: ("Cerca"),
      //   activeColorPrimary: isAndroid
      //       ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
      //       : CupertinoTheme.of(context).primaryColor,
      //   inactiveColorPrimary: isAndroid
      //       ? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!
      //       : CupertinoTheme.of(context).primaryContrastingColor,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_rounded),
        title: "Impostazioni",
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: isAndroid
            ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
            : CupertinoTheme.of(context).primaryColor,
        inactiveColorPrimary: isAndroid
            ? Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!
            : CupertinoTheme.of(context).primaryContrastingColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);
    //ANDROID
    Scaffold materialScaffold = Scaffold(
      body: PersistentTabView(
        context,
        controller: controller,
        navBarHeight: 75,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor:
            Theme.of(context).bottomAppBarColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        // screenTransitionAnimation: const ScreenTransitionAnimation(
        //   // Screen transition animation on change of selected tab.
        //   animateTabTransition: true,
        //   curve: Curves.ease,
        //   duration: Duration(milliseconds: 200),
        // ),
        navBarStyle:
            NavBarStyle.style9, // Choose the nav bar style with this property.
      ),

      /*body: IndexedStack(
        index: _page,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        selectedItemColor: const Color.fromARGB(255, 39, 108, 255),
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
      ),*/
    );

    //iOS
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
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.search),
          //   label: Constants.search,
          // ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: Constants.settings,
          ),
        ],
      ),
      tabBuilder: (_, index) => CupertinoTabView(
        builder: (context) => CupertinoScaffold(
          body: _buildScreens()[index],
        ),
      ),
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? cupertinoPageScaffold
        : materialScaffold;
  }
}
