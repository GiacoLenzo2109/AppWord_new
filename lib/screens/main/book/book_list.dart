import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/providers/book_list_model.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/add_book.dart';
import 'package:app_word/screens/main/book/book.dart';
import 'package:app_word/screens/main/book/join_book_page.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/book_item.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:app_word/widgets/global/pin_text_field.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  var pinController = TextEditingController();

  var loaded = false;
  late Future<bool> _loaded;

  @override
  Widget build(BuildContext context) {
    final bookListProvider = Provider.of<BookListProvider>(context);

    /// Fetch all books
    Future<List<Book>> fetchBooks() async {
      return await BookRepository.getAllBooks(context: context);
    }

    /// Fetch data
    Future<bool> fetchData() async {
      if (FirebaseGlobal.auth.currentUser != null) {
        // var word = await FirestoreRepository.getDailyWord();
        // if (word.docs.isNotEmpty) {
        //   dailyWord = Word.fromSnapshot(
        //       word.docs.first.data() as Map<String, dynamic>,
        //       word.docs.first.id);
        // }
        if (bookListProvider.books.isEmpty) {
          bookListProvider.setBooks(await fetchBooks());
        }
        loaded = true;

        return true;
      }
      return false;
    }

    Widget buildTrailing() {
      return Padding(
        padding: EdgeInsets.only(
          right: Theme.of(context).platform == TargetPlatform.android ? 10 : 0,
        ),
        child: GestureDetector(
          child: Icon(
            CupertinoIcons.add,
            color: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoColors.activeBlue
                : Theme.of(context).appBarTheme.titleTextStyle!.color,
            size: 25,
          ),
          onTap: () => DialogUtil.showModalBottomSheet(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<BookListProvider>.value(
              value: bookListProvider,
              child: const AddBookPage(),
            ),
          ),
        ),
      );
    }

    Widget buildBooksView() {
      return StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        children: [
          for (Book book in bookListProvider.books)
            ChangeNotifierProvider.value(
              value: bookListProvider.getBookProvider(book.id),
              child: BookItem(book: book),
            ),
          ButtonWidget(
            text: "Unisciti ad una rubrica",
            backgroundColor:
                ThemesUtil.getPrimaryColor(context).withOpacity(.95),
            icon: const Icon(
              CupertinoIcons.add,
              color: CupertinoColors.white,
            ),
            onPressed: () => DialogUtil.showModalBottomSheet(
              context: context,
              builder: (context) => JoinBookPage(
                pinController: pinController,
                onFinish: (book) {
                  bookListProvider.addBook(book);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget buildEmptyView() {
      return GestureDetector(
        onTap: () => DialogUtil.showModalBottomSheet(
          context: context,
          builder: (context) => JoinBookPage(
            pinController: pinController,
            onFinish: (book) {
              bookListProvider.addBook(book);
              Navigator.pop(context);
            },
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          height: ScreenUtil.getSize(context).height - 275,
          child: Center(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 15,
              children: [
                Icon(
                  CupertinoIcons.doc_append,
                  size: ScreenUtil.getSize(context).width / 4,
                  color: CupertinoColors.systemGrey,
                ),
                const Text(
                  "Entra in una rubrica!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(CupertinoIcons.add_circled_solid),
              ],
            ),
          ),
        ),
      );
    }

    if (!loaded) {
      _loaded = fetchData();
    }

    return PageScaffold(
      scrollable: loaded && bookListProvider.books.isNotEmpty ? true : false,
      title: "Elenco",
      onRefresh: loaded
          ? () async {
              bookListProvider.setBooks(await fetchBooks());
            }
          : null,
      trailing: buildTrailing(),
      child: FutureBuilder(
        future: _loaded,
        builder: (context, snapshot) => loaded
            ? bookListProvider.books.isNotEmpty
                ? buildBooksView()
                : buildEmptyView()
            : SizedBox(
                height: ScreenUtil.getSize(context).height - 275,
                child: const Center(
                  child: LoadingWidget(),
                ),
              ),
      ),
    );
  }
}
