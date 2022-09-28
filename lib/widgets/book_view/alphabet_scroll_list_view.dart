import 'dart:developer' as dev;
import 'dart:ui';

import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/screens/main/book/join_book_page.dart';
import 'package:app_word/screens/main/book/word/new_word_page.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/spinner_refresh_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:app_word/widgets/global/bottom_picker.dart';
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
  final ScrollController scrollController;

  const AlphabetScrollListView({
    Key? key,
    required this.book,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<AlphabetScrollListView> createState() => _AlphabetScrollListViewState();
}

class _AlphabetScrollListViewState extends State<AlphabetScrollListView> {
  final double jumpShiftLetter = 35;
  final double jumpShiftWord = 50;

  final List<Word> _words = [];

  var selectedLetter = "A";

  bool searching = false;
  var searchValue = "";

  bool searchIsPinned = false;

  /// Alphabet list letters

  List<String> _alphabet = [];
  var alphabetLetterPositions = {};

  double _delta = 0;

  StickyHeaderController controller = StickyHeaderController();

  /// This variable holds the positions in the ListView. We need that to implement
  /// the functionality of the direct jump to the given letter in the list
  Map<String, double> letterPositions = {};

  int _letterPos = 0;

  @override
  void initState() {
    super.initState();
  }

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

    // dev.log(widget.scrollController.offset.toDouble().toString());

    void initWords(Map<String, List<Word>> wordsMap,
        Map<String, Word> wordsMapMain, List<Word> words) {
      if (wordsMap.isEmpty) {
        for (Word word in words) {
          if (word.word.isNotEmpty) {
            if (wordsMap[word.word[0]] == null) {
              wordsMap.putIfAbsent(word.word[0], () => []);
            }
            wordsMap[word.word[0]]!.add(word);
            wordsMapMain.putIfAbsent(word.word, () => word);
          }
        }
      }
    }

    Widget buildEmptyView() {
      return SliverFillRemaining(
        child: GestureDetector(
          onTap: () => DialogUtil.showModalBottomSheet(
            context: context,
            builder: (context) => ChangeNotifierProvider<BookModel>.value(
              value: bookProvider,
              child: const AddWordPage(),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 100),
            decoration: const BoxDecoration(color: Colors.transparent),
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
        ),
      );
    }

    List<Widget> getWordList(List<Word> words) {
      _words.clear();
      _words.addAll(words);
      List<Widget> slivers = [];
      Map<String, List<Word>> map = {};
      double totalShift = ThemesUtil.isAndroid(context) ? 0 : 55;

      initWords(map, {}, words);

      for (var letter in map.keys) {
        letterPositions[letter] = 0;
        // int l = map[letter]!.length;
        // int ct = 0;

        letterPositions[letter] = totalShift;

        // dev.log('$letter $totalShift');

        totalShift += jumpShiftLetter;

        for (Word word in map[letter]!) {
          totalShift += jumpShiftWord;
        }
        totalShift += 25;

        slivers.add(
          SliverStickyHeader.builder(
            controller: controller,
            builder: (context, state) {
              return ClipRect(
                clipBehavior: Clip.hardEdge,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: ThemesUtil.isAndroid(context) ? 0 : 10.0,
                    sigmaY: ThemesUtil.isAndroid(context) ? 0 : 9.5,
                  ),
                  child: Container(
                    height: 35,
                    // decoration: BoxDecoration(
                    // border: Border(
                    //   bottom: BorderSide(
                    //     color: state.isPinned
                    //         ? CupertinoColors.systemGrey4
                    //         : ThemesUtil.getBackgroundColor(context),
                    //   ),
                    // ),
                    color: ThemesUtil.isAndroid(context)
                        ? ThemesUtil.getPrimaryColor(context).withOpacity(
                            !state.isPinned
                                ? state.scrollPercentage
                                : ThemesUtil.isAndroid(context)
                                    ? 1
                                    : 0.5,
                          )
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
                    // ),
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ThemesUtil.isAndroid(context)
                            ? state.isPinned
                                ? Colors.white
                                : ThemesUtil.getPrimaryColor(context)
                            : ThemesUtil.getTextColor(context),
                      ),
                    ),
                  ),
                ),
              );
            },
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Widget child = Container(
                    padding: const EdgeInsets.only(left: 10, right: 25),
                    height: map[letter]!.elementAt(index).word ==
                            map[letter]!.last.word
                        ? 75
                        : 50,
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
                        // if (map[letter]!.elementAt(index).word ==
                        //         map[letter]!.last.word &&
                        //     letter == map.keys.last)
                        //   const SizedBox(
                        //     height: 35,
                        //   ),
                      ],
                    ),
                  );
                  // totalShift += 25;
                  return child;
                },
                childCount: map[letter]!.length,
              ),
            ),
          ),
        );
        // totalShift += 25;
      }
      return slivers;
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
        ...getWordList(wordsSearched),
      ];
    }

    List<Widget> getWordsList() {
      return searching ? getSearchResult() : getWordList(words());
    }

    List<Widget> getStartingLetters() {
      /// This functions goes through all contacts details and finds all starting
      /// letters of the names in the list. They are later used to implement quick
      /// jump to the letter functionality

      /// For simplicity, use set to keep unique letter
      Set<String> outSet = {};
      for (Word word in _words) {
        if (word.word.isNotEmpty) {
          outSet.add(word.word[0]);
        }
      }

      /// We then need to sort that letters in the alphabetical order
      var outList = outSet.toList();
      outList.sort();

      setState(() {
        _alphabet = outList;
      });

      // _alphabet.add('G');
      // _alphabet.add('H');
      // _alphabet.add('I');
      // _alphabet.add('P');
      // _alphabet.add('O');
      // _alphabet.add('N');
      // _alphabet.add('X');

      Widget buildLetterButton(Function() onPressed, String letter) {
        return SizedBox(
          width: 10,
          height: 25,
          child: GestureDetector(
            onTapDown: (details) {
              onPressed();
            },
            onVerticalDragStart: (_) {},
            child: Text(
              letter,
              textAlign: TextAlign.center,
              style: ThemesUtil.titleContainerStyle(context).copyWith(
                color: ThemesUtil.getTextColor(context),
                fontSize: 12.5,
                //fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      }

      /// Now we just build a list of children for the small Column on the right
      /// hand side
      List<Widget> out = [];
      for (var l in outList) {
        out.add(
          buildLetterButton(
            () {
              dev.log("Pressed: $l");

              widget.scrollController.jumpTo(letterPositions[l]! <=
                      widget.scrollController.position.maxScrollExtent
                  ? letterPositions[l]!
                  : widget.scrollController.position.maxScrollExtent);

              setState(() {
                selectedLetter = l;
              });
            },
            l,
          ),
        );
      }
      return out;
    }

    var sliver = SliverPadding(
      padding: const EdgeInsets.all(0),
      sliver: SliverStickyHeader.builder(
        controller: controller,
        builder: (context, state) {
          if (mounted) {
            Future.delayed(
              const Duration(seconds: 0),
              () => setState(() {
                searchIsPinned = state.isPinned;
              }),
            );
          }
          return const SizedBox();
        },
        sliver: SliverPadding(
          padding: const EdgeInsets.all(0),
          sliver: MultiSliver(
            children: [
              SliverPinnedHeader(
                child: ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: ThemesUtil.isAndroid(context) ? 0 : 10.0,
                      sigmaY: ThemesUtil.isAndroid(context) ? 0 : 9.5,
                    ),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: searchIsPinned
                                ? CupertinoColors.systemGrey4.withOpacity(.35)
                                : ThemesUtil.getBackgroundColor(context),
                          ),
                        ),
                        color: ThemesUtil.isAndroid(context)
                            ? ThemesUtil.getPrimaryColor(context).withOpacity(
                                !searchIsPinned
                                    ? 0
                                    : ThemesUtil.isAndroid(context)
                                        ? 1
                                        : 0.5,
                              )
                            : CupertinoTheme.of(context)
                                .barBackgroundColor
                                .withOpacity(
                                  !searchIsPinned
                                      ? 0
                                      : Provider.of<ThemeProvider>(context)
                                              .isDarkTheme
                                          ? 1
                                          : 0.5,
                                ),
                      ),
                      padding: Constants.padding,
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
                  ),
                ),
              ),
              ...getWordsList(),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 35),
                child: Text(
                  "${_words.length} vocaboli",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemesUtil.getTextColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

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
        if (bookProvider.words.isNotEmpty)
          SliverStack(
            children: [
              sliver,
              SliverPinnedHeader(
                child: Container(
                  width: 5,
                  height: ScreenUtil.getSize(context).height -
                      MediaQuery.of(
                        NavigationService.navigatorKey.currentContext!,
                      ).viewInsets.bottom -
                      MediaQuery.of(
                        NavigationService.navigatorKey.currentContext!,
                      ).viewInsets.top -
                      (ThemesUtil.isAndroid(context) ? 75 : 0),
                  // color: Colors.red,
                  padding: const EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: getStartingLetters(),
                  ),
                ),
              ),
            ],
          ),
        if (bookProvider.words.isEmpty && !searching) buildEmptyView()
      ],
    );
  }
}
