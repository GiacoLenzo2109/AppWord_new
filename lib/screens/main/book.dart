// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/models/book_model.dart';
import 'package:app_word/models/navbar_model.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/alphabet_scroll_list.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/material_tab_indicator.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/tab_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class Book extends StatefulWidget {
  const Book({Key? key}) : super(key: key);

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final navbarProvider = Provider.of<NavbarModel>(context);
    final bookProvider = Provider.of<BookModel>(context);

    return PageScaffold(
      title: "Rubrica",
      padding: 0,
      onRefresh: () async {
        //TO-DO: Refresh delle parole nella rubrica (da decidere ancora se farlo o no)
      },
      scrollable: false,
      leading: Theme.of(context).platform == TargetPlatform.android
          ? GestureDetector(
              onTap: () => navbarProvider.tapLeading(),
              child: Icon(!navbarProvider.leading ? Icons.edit : Icons.done),
            )
          : CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => navbarProvider.tapTrailing(),
              child: Text(
                !navbarProvider.leading ? "Modifica" : "Fatto",
              ),
            ),
      trailing: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            !navbarProvider.leading ? CupertinoIcons.add : CupertinoIcons.trash,
            color:
                navbarProvider.leading ? Colors.redAccent : Colors.greenAccent,
            size: 25,
          ),
        ),
        onTap: () {
          if (navbarProvider.leading) {
            for (var word
                in bookProvider.selectedWords[bookProvider.selectedBook]!) {
              bookProvider.remove(bookProvider.selectedBook, word);
            }
            navbarProvider.tapLeading();
          }
        },
      ),
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        children: [
          TabBarWidget(
            onValueChanged: (value) {
              bookProvider.setSelectedBook(
                value == 0 ? Constants.personalBook : Constants.classBook,
              );
            },
            tabs: const [Constants.personalBook, Constants.classBook],
            tabsView: const [
              AlphabetScrollList(Constants.personalBook),
              AlphabetScrollList(Constants.classBook),
            ],
          ),
        ],
      ),
    );
  }
}
