// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/others/new_word_page.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/alphabet_scroll_list.dart';
import 'package:app_word/widgets/book_view/alphabet_scroll_list_view.dart';
import 'package:app_word/widgets/global/search_text_field.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/tab_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Book extends StatefulWidget {
  const Book({Key? key}) : super(key: key);

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> with SingleTickerProviderStateMixin {
  var personalBook = const AlphabetScrollList(Constants.personalBook);
  var classBook = const AlphabetScrollList(Constants.classBook);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navbarProvider = Provider.of<NavbarModel>(context);
    final bookProvider = Provider.of<BookModel>(context);

    return PageScaffold(
      title:
          ThemesUtil.isAndroid(context) ? "Rubrica" : bookProvider.selectedBook,
      padding: 0,
      onRefresh: () async {
        //TO-DO: Refresh delle parole nella rubrica (da decidere ancora se farlo o no)
      },
      rounded: false,
      scrollable: true,
      leading: Theme.of(context).platform == TargetPlatform.android
          ? GestureDetector(
              onTap: () => navbarProvider.tapLeading(),
              child: Icon(
                !navbarProvider.leading ? Icons.edit : Icons.done,
                color: Theme.of(context).appBarTheme.titleTextStyle!.color,
              ),
            )
          : CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => navbarProvider.tapLeading(),
              child: Text(
                !navbarProvider.leading ? "Modifica" : "Fatto",
                style: const TextStyle(fontSize: 17),
              ),
            ),
      trailing: Padding(
        padding: EdgeInsets.only(
          right: Theme.of(context).platform == TargetPlatform.android ? 10 : 0,
        ),
        child: GestureDetector(
          child: Icon(
            !navbarProvider.leading ? CupertinoIcons.add : CupertinoIcons.trash,
            color: navbarProvider.leading
                ? Colors.redAccent
                : Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoColors.activeBlue
                    : Theme.of(context).appBarTheme.titleTextStyle!.color,
            size: 25,
          ),
          onTap: () {
            if (navbarProvider.leading) {
              for (var word
                  in bookProvider.selectedWords[bookProvider.selectedBook]!) {
                bookProvider.remove(bookProvider.selectedBook, word);
              }
              log(bookProvider.words.toString());
              navbarProvider.tapLeading();
            } else {
              DialogUtil.showModalBottomSheet(
                  context: context, builder: (context) => const AddWordPage());
            }
          },
        ),
      ),
      childSliver: AlphabetScrollListView(book: bookProvider.selectedBook),
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        children: [
          if (Theme.of(context).platform == TargetPlatform.iOS)
            const SizedBox(height: 25),
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
