import 'dart:developer';
import 'dart:math';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/database/repository/daily_word_repository.dart';
import 'package:app_word/database/repository/user_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/providers/book_list_model.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/screens/main/book/add_book.dart';
import 'package:app_word/screens/main/book/book.dart';
import 'package:app_word/screens/main/book/word/new_word_page.dart';
import 'package:app_word/screens/main/book/word/word_page.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/book_item.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/container_widget.dart';
import 'package:app_word/widgets/global/icon_button_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:app_word/widgets/global/pin_text_field.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<bool> _loaded;
  bool loaded = false;
  bool isAdmin = false;
  bool noWords = true;
  Word dailyWord = Word();

  var emoji = Constants.emojis[math.Random().nextInt(Constants.emojis.length)];

  @override
  Widget build(BuildContext context) {
    final bookListProvider = Provider.of<BookListProvider>(context);
    final dailyWordProvider = Provider.of<BookModel>(context);

    Future<List<Book>> fetchBooks() async {
      return await BookRepository.getAllBooks(context: context);
    }

    Future<Word?> fetchDailyWord() async {
      return await DailyWordRepository.getDailyWord(context: context);
    }

    Future<void> fetchUserData() async {
      var user = await UserRepository.getUser(
          context: context, uid: FirebaseGlobal.auth.currentUser!.uid);

      setState(() {
        isAdmin = user!.isAdmin;
      });
    }

    Future<bool> fetchData() async {
      if (FirebaseGlobal.auth.currentUser != null) {
        var books = await fetchBooks();
        bookListProvider.setBooks(books);

        var word = await fetchDailyWord();
        setState(() {
          if (word != null) {
            dailyWord = word;
          } else {
            dailyWord = Word();
          }
        });

        dailyWordProvider.addWord(dailyWord);

        await fetchUserData();

        setState(() {
          loaded = true;
        });
        return true;
      }
      return false;
    }

    if (!loaded) {
      setState(() {
        _loaded = fetchData();
      });
    }

    List<Widget> newWords = [];

    for (int i = 0; i < 5; i++) {
      newWords.add(ButtonWidget(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        text: (i + 1).toString(),
      ));
    }

    Widget buildEmptyHome() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          children: const [
            Text(
              "Vai qui!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemGrey,
              ),
            ),
            Icon(
              CupertinoIcons.arrow_down,
              color: CupertinoColors.systemGrey,
              size: 35,
            ),
          ],
        ),
      );
    }

    Widget buildFullHome() {
      return StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 25,
        children: [
          ContainerWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 65),
                ),
                Text(
                  "@ ${FirebaseGlobal.auth.currentUser?.displayName!}",
                  style: ThemesUtil.titleContainerStyle(context),
                )
              ],
            ),
          ),
          if (dailyWordProvider.words.isNotEmpty)
            // New word
            ContainerWidget(
              child: GestureDetector(
                onTap: () => NavigatorUtil.navigateTo(
                  isOnRoot: true,
                  context: context,
                  builder: (context) => ChangeNotifierProvider.value(
                    value: dailyWordProvider,
                    child: ThemesUtil.isAndroid(context)
                        ? WordPage(
                            word: dailyWordProvider.words.first,
                            isDailyWord: true,
                            isAdmin: isAdmin,
                          )
                        : CupertinoScaffold(
                            body: WordPage(
                              word: dailyWordProvider.words.first,
                              isDailyWord: true,
                              isAdmin: isAdmin,
                            ),
                          ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parola del giorno:",
                            style: ThemesUtil.titleContainerStyle(context),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: ScreenUtil.getSize(context).width / 2,
                            child: Text(
                              dailyWordProvider.words.first.word,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Theme.of(context).platform ==
                                        TargetPlatform.android
                                    ? Theme.of(context).primaryColor
                                    : CupertinoTheme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.amber[400],
                      child: Padding(
                        padding: Constants.padding,
                        child: Icon(
                          Icons.lightbulb_rounded,
                          size: ScreenUtil.getSize(context).height / 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Rubriche
          ContainerWidget(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              children: [
                Text(
                  "Rubriche:",
                  style: ThemesUtil.titleContainerStyle(context),
                ),
                Container(
                  margin: const EdgeInsets.all(7.5),
                  color: Colors.grey,
                  height: 1,
                ),
                StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    for (BookModel book in bookListProvider.bookProviders)
                      ButtonWidget(
                        text: book.name,
                        backgroundColor: ThemesUtil.getBackgroundColor(context),
                        textColor: ThemesUtil.getTextColor(context),
                        onPressed: () => NavigatorUtil.navigateTo(
                          context:
                              NavigationService.navigatorKey.currentContext!,
                          builder: (context) => ChangeNotifierProvider.value(
                            value: book,
                            child: const CupertinoScaffold(
                              body: BookPage(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // ContainerWidget(
          //   child: StaggeredGrid.count(
          //     crossAxisCount: 1,
          //     mainAxisSpacing: 10,
          //     children: [
          //       Text(
          //         "Classifica utenti:",
          //         style: ThemesUtil.titleContainerStyle(context),
          //       ),
          //       Container(
          //         margin: const EdgeInsets.all(7.5),
          //         color: Colors.grey,
          //         height: 1,
          //       ),
          //       StaggeredGrid.count(
          //         crossAxisCount: 1,
          //         mainAxisSpacing: 10,
          //         crossAxisSpacing: 10,
          //         children: [
          //           for (String user
          //               in bookListProvider.bookProviders.first.usersRanking)
          //             Row(
          //               children: [
          //                 Text(
          //                   "1.   ",
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color: ThemesUtil.getTextColor(context),
          //                   ),
          //                 ),
          //                 Text(
          //                   user,
          //                   style: TextStyle(
          //                     fontSize: 15,
          //                     fontWeight: FontWeight.bold,
          //                     color: ThemesUtil.getTextColor(context),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),

          //Lista nuove parole
          // if (!bookListProvider.booksAreEmpty())
          //   ContainerWidget(
          //     child: StaggeredGrid.count(
          //       crossAxisCount: 1,
          //       mainAxisSpacing: 10,
          //       children: [
          //         Text(
          //           "Nuove parole:",
          //           style: ThemesUtil.titleContainerStyle(context),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.all(7.5),
          //           color: Colors.grey,
          //           height: 1,
          //         ),
          //         StaggeredGrid.count(
          //           crossAxisCount: 1,
          //           mainAxisSpacing: 10,
          //           children: [
          //             for (Book book in bookListProvider.books.getRange(
          //                 0,
          //                 bookListProvider.books.length < 5
          //                     ? bookListProvider.books.length
          //                     : 5))
          //               if (bookListProvider
          //                   .getBookProvider(book.id)
          //                   .wordsByTimestamp
          //                   .isNotEmpty)
          //                 StaggeredGrid.count(
          //                   crossAxisCount: 1,
          //                   mainAxisSpacing: 10,
          //                   children: [
          //                     ChangeNotifierProvider.value(
          //                       value:
          //                           bookListProvider.getBookProvider(book.id),
          //                       child: WordItem(
          //                         word: bookListProvider
          //                             .getBookProvider(book.id)
          //                             .wordsByTimestamp
          //                             .first,
          //                         book: book.id,
          //                         isNotInAlphabet: true,
          //                         isAdmin: isAdmin,
          //                       ),
          //                     ),
          //                     const Divider(color: Colors.grey),
          //                   ],
          //                 ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          if (isAdmin)
            GestureDetector(
              onTap: () => DialogUtil.showModalBottomSheet(
                context: context,
                builder: (context) => ChangeNotifierProvider.value(
                  value: dailyWordProvider,
                  child: const AddWordPage(isDailyWord: true),
                ),
              ),
              child: const ContainerWidget(
                padding: 10,
                child: Icon(
                  CupertinoIcons.add_circled,
                  size: 50,
                ),
              ),
            ),
        ],
      );
    }

    return PageScaffold(
      title: "Home",
      onRefresh: loaded && bookListProvider.books.isNotEmpty
          ? () async {
              await fetchData();
            }
          : null,
      scrollable: loaded && bookListProvider.books.isNotEmpty ? true : false,
      child: FutureBuilder(
        future: _loaded,
        builder: (context, snapshot) => loaded
            ? bookListProvider.books.isNotEmpty
                ? buildFullHome()
                : buildEmptyHome()
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
