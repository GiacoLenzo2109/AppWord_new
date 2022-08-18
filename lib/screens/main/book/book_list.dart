import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/book.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BookList extends StatelessWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buildList() {
      List<Widget> items = [];

      for (var book in [Constants.personalBook, Constants.classBook]) {
        items.add(
          // StaggeredGrid.count(
          //   crossAxisCount: 1,
          //   children: [
          //     // Text(
          //     //   book,
          //     //   style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          //     // ),
          //     ButtonWidget(text: book)
          //   ],
          // ),
          ButtonWidget(
            text: book,
            padding: 15,
            backgroundColor: ThemesUtil.isAndroid(context)
                ? Theme.of(context).backgroundColor
                : CupertinoThemes.backgroundColor(context),
            icon: Icon(
              book == Constants.personalBook
                  ? CupertinoIcons.person
                  : CupertinoIcons.person_2,
            ),
            suffixIcon: const Icon(CupertinoIcons.arrow_right),
            onPressed: () {
              var bookProvider = BookModel();
              bookProvider.setSelectedBook(book);
              NavigatorUtil.navigateTo(
                context: context,
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => NavbarModel(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => bookProvider,
                    ),
                  ],
                  builder: (context, _) => const CupertinoScaffold(
                    body: Book(),
                  ),
                ),
              );
            },
          ),
        );
      }
      return items;
    }

    return PageScaffold(
      scrollable: false,
      title: "Elenco",
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        children: buildList(),
      ),
    );
  }
}
