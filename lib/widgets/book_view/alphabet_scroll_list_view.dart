import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/screens/main/book/join_book_page.dart';
import 'package:app_word/screens/main/book/word/new_word_page.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/spinner_refresh_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/divider_widget.dart';
import 'package:app_word/widgets/global/search_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../providers/book_model.dart';

class AlphabetScrollListView extends StatefulWidget {
  final String book;

  const AlphabetScrollListView({Key? key, required this.book})
      : super(key: key);

  @override
  State<AlphabetScrollListView> createState() => _AlphabetScrollListViewState();
}

class _AlphabetScrollListViewState extends State<AlphabetScrollListView> {
  final double jumpShiftLetter = 25;
  final double jumpShiftWord = 50;

  var selectedLetter = "A";

  bool searching = false;
  var searchValue = "";

  StickyHeaderController controller = StickyHeaderController();

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookModel>(context);

    List<Word> words() => bookProvider.words;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (words().isEmpty) {
    //     for (var word in _words) {
    //       bookProvider.add(widget.book, word);
    //     }
    //     words().sort();
    //   }
    // });

    void initWords(Map<String, List<Word>> wordsMap,
        Map<String, Word> wordsMapMain, List<Word> words) {
      if (wordsMap.isEmpty) {
        for (Word word in words) {
          if (wordsMap[word.word[0]] == null) {
            wordsMap.putIfAbsent(word.word[0], () => []);
          }
          wordsMap[word.word[0]]!.add(word);
          wordsMapMain.putIfAbsent(word.word, () => word);
        }
      }
    }

    // void initWords(Map<String, List<Word>> wordsMap,
    //     Map<String, Word> wordsMapMain, List<String> words) {
    //   if (wordsMap.isEmpty) {
    //     for (String word in words) {
    //       if (wordsMap[word[0]] == null) {
    //         wordsMap.putIfAbsent(word[0], () => []);
    //       }
    //       wordsMap[word[0]]!.add(
    //         Word(
    //           type: Word.verb,
    //           word: word,
    //           definitions: ['def1', 'def2'],
    //           semanticFields: ['sem1', 'sem2'],
    //           examplePhrases: ['ex1', 'ex2'],
    //           italianType: Word.literature,
    //           italianCorrespondence: 'Pog',
    //           synonyms: ['s1'],
    //           antonyms: ['a1', 'a2', 'a3'],
    //         ),
    //       );
    //       wordsMapMain.putIfAbsent(
    //         word,
    //         () => Word(
    //           type: Word.verb,
    //           word: word,
    //           definitions: ['def1', 'def2'],
    //           semanticFields: ['sem1', 'sem2'],
    //           examplePhrases: ['ex1', 'ex2'],
    //           italianType: Word.literature,
    //           italianCorrespondence: 'Pog',
    //           synonyms: ['s1'],
    //           antonyms: ['a1', 'a2', 'a3'],
    //         ),
    //       );
    //     }
    //   }
    // }

    // initWords(_wordsMap, _wordsMapMain, wordsString(words()));

    var searchSliver = SliverPadding(
      padding: Constants.padding,
      sliver: SliverStickyHeader.builder(
        builder: (context, state) => SizedBox(
          height: 35,
          child: SearchTextField(
            onChanged: (searchValue) {
              setState(() {
                searching = true;
                searching = searchValue.isNotEmpty;
                this.searchValue = searchValue.toLowerCase();
              });
            },
            onStop: (() {
              setState(() {
                searching = false;
                searchValue = "";
                FocusScope.of(context).unfocus();
              });
            }),
          ),
        ),
        sliver: const SliverPadding(padding: Constants.padding),
      ),
    );

    List<Widget> getWordList(List<Word> words) {
      List<Widget> slivers = [];
      Map<String, List<Word>> map = {};

      initWords(map, {}, words);

      for (var letter in map.keys) {
        slivers.add(
          SliverStickyHeader.builder(
            controller: controller,
            builder: (context, state) => ClipRect(
              clipBehavior: Clip.hardEdge,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 9.5),
                child: Container(
                  color: ThemesUtil.isAndroid(context)
                      ? Theme.of(context).scaffoldBackgroundColor.withOpacity(
                          !state.isPinned ? state.scrollPercentage : 0.5)
                      : CupertinoTheme.of(context)
                          .barBackgroundColor
                          .withOpacity(
                            !state.isPinned
                                ? state.scrollPercentage
                                : Provider.of<ThemeProvider>(context)
                                        .isDarkTheme
                                    ? 1
                                    : 0.5,
                          ),
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(letter),
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      Divider(
                        height: 0,
                        color: Colors.grey.withOpacity(.5),
                      ),
                      WordItem(
                        key: Key(map[letter]!.elementAt(index).id),
                        word: map[letter]!.elementAt(index),
                        book: widget.book,
                      ),
                      Divider(
                        height: 0,
                        color: Colors.grey.withOpacity(.5),
                      ),
                      if (map[letter]!.elementAt(index).word ==
                          map[letter]!.last.word)
                        const SizedBox(height: 25),
                      if (map[letter]!.elementAt(index).word ==
                              map[letter]!.last.word &&
                          letter == map.keys.last)
                        const SizedBox(
                          height: 100,
                        ),
                    ],
                  ),
                ),
                childCount: map[letter]!.length,
              ),
            ),
          ),
        );
      }
      return words.isEmpty
          ? [
              GestureDetector(
                onTap: () => DialogUtil.showModalBottomSheet(
                  context: context,
                  builder: (context) => ChangeNotifierProvider<BookModel>.value(
                    value: bookProvider,
                    child: const AddWordPage(),
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  height: ScreenUtil.getSize(context).height - 350,
                  child: Center(
                    child: StaggeredGrid.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      children: [
                        Icon(
                          CupertinoIcons.pencil_ellipsis_rectangle,
                          size: ScreenUtil.getSize(context).width / 4,
                          color: CupertinoColors.systemGrey,
                        ),
                        const Text(
                          "Aggiungi un vocabolo!",
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
              )
            ]
          : slivers;
    }

    List<Widget> getSearchResult() {
      /// Lists all the contacts that were matched against the search query.
      /// Pretty straightForward. Go through the list and check if substring matches
      /// any contacts
      List<Word> wordsSearched = [];

      for (var word in bookProvider.words) {
        if (!word.word.toLowerCase().contains(searchValue)) {
          continue;
        }
        wordsSearched.add(word);
      }

      return [
        SliverStickyHeader.builder(
          controller: controller,
          builder: (context, state) => Container(
            color: (ThemesUtil.isAndroid(context)
                    ? Theme.of(context).scaffoldBackgroundColor
                    : CupertinoTheme.of(context).barBackgroundColor)
                .withOpacity(!state.isPinned ? state.scrollPercentage : 1),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(wordsSearched.isEmpty
                ? "Nessun risultato!"
                : "Risultati ricerca:"),
          ),
          sliver: const SliverPadding(padding: Constants.padding),
        ),
        MultiSliver(children: getWordList(wordsSearched)),
      ];
    }

    List<Widget> getWordsList() {
      return searching ? getSearchResult() : getWordList(words());
    }

    return MultiSliver(
      children: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            bookProvider.setWords(
              await BookRepository.getWords(
                  context: context, bookId: bookProvider.id),
            );
          },
          builder: SpinnerRefreshUtil.buildSpinnerOnlyRefreshIndicator,
        ),
        if (bookProvider.words.isNotEmpty) searchSliver,
        MultiSliver(
          children: getWordsList(),
        ),
      ],
    );
  }
}
