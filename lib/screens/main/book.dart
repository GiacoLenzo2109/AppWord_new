// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/others/new_word_page.dart';
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
              child: Icon(
                !navbarProvider.leading ? Icons.edit : Icons.done,
                color: CupertinoColors.activeBlue,
              ),
            )
          : CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => navbarProvider.tapLeading(),
              child: Text(
                !navbarProvider.leading ? "Modifica" : "Fatto",
              ),
            ),
      trailing: GestureDetector(
        child: Icon(
          !navbarProvider.leading ? CupertinoIcons.add : CupertinoIcons.trash,
          color: navbarProvider.leading
              ? Colors.redAccent
              : CupertinoColors.activeBlue,
          size: 25,
        ),
        onTap: () {
          if (navbarProvider.leading) {
            for (var word
                in bookProvider.selectedWords[bookProvider.selectedBook]!) {
              bookProvider.remove(bookProvider.selectedBook, word);
            }
            navbarProvider.tapLeading();
          } else {
            CupertinoScaffold.showCupertinoModalBottomSheet(
                context: context, builder: (context) => const AddWordPage());
          }
        },
      ),
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        children: [
          const SizedBox(height: 20),
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
