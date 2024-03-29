// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/word/new_word_page.dart';
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

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final navbarProvider = Provider.of<NavbarModel>(context);
    final bookProvider = Provider.of<BookModel>(context);
    bool isSetted = false;

    if (!isSetted) {
      scrollController.addListener(() {
        bookProvider.isStickyAlphabeth = !scrollController.offset.isNegative;
      });
      isSetted = true;
    }

    return PageScaffold(
      title: bookProvider.name,
      padding: 0,
      controller: scrollController,
      scrollable: bookProvider.words.isEmpty ? false : true,
      trailing: Padding(
        padding: EdgeInsets.only(
          right: Theme.of(context).platform == TargetPlatform.android ? 10 : 0,
        ),
        child: GestureDetector(
          child: Icon(
            !navbarProvider.leading ? CupertinoIcons.add : CupertinoIcons.trash,
            color: navbarProvider.leading
                ? Colors.redAccent
                : !ThemesUtil.isAndroid(context)
                    ? CupertinoColors.activeBlue
                    : Theme.of(context).appBarTheme.titleTextStyle!.color,
            size: 25,
          ),
          onTap: () {
            // if (navbarProvider.leading) {
            //   for (var word
            //       in bookProvider.selectedWords[bookProvider.selectedBook]!) {
            //     bookProvider.removeWord(word);
            //   }
            //   log(bookProvider.words.toString());
            //   navbarProvider.tapLeading();
            // } else {
            DialogUtil.showModalBottomSheet(
              context: context,
              builder: (_) => ChangeNotifierProvider.value(
                value: bookProvider,
                child: const AddWordPage(),
              ),
            );
            //}
          },
        ),
      ),
      childSliver: ChangeNotifierProvider.value(
        value: bookProvider,
        child: AlphabetScrollListView(
          book: bookProvider.id,
          scrollController: scrollController,
        ),
      ),
      //child: AlphabetScrollList(bookProvider.id),
    );
  }
}
