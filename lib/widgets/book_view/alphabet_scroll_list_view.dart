import 'dart:collection';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:app_word/models/word.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/spinner_refresh_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
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
  final _words = [
    "Alpha",
    "Beta",
    "Cami",
    "Elio",
    "Elio1",
    "Elio2",
    "Elio4",
    "Elio3",
    "Elio5",
    "Giaco",
    "Giaco1",
    "Giaco2",
    "Giaco3",
    "Giaco4",
    "Giaco5",
    "Giaco6",
    "Giaco7",
    "Giaco8",
    "Giaco9",
    "Giaco10",
    "Lenzo",
    "Zorro3123",
    "Zorro32134",
    "Zorro34524",
    "Zorrorthg2",
    "Zorrot2351rf",
    "Zorrotrqwer",
    "Zorro54t2qf",
    "Zorrt3213to",
    "Zorrogwqe",
    "Zorrowefa",
    "Zorrofr3",
    "Zorrofc",
    "Zorrogeqt4",
    "Zorrofsaf",
    "Zorrosadvnjrtew",
    "Zorro1",
    "Zorr2",
    "Zorr3"
  ];

  final Map<String, List<Word>> _wordsMap = {};
  final Map<String, Word> _wordsMapMain = {};

  final double jumpShiftLetter = 25;
  final double jumpShiftWord = 50;

  var selectedLetter = "A";

  bool searching = false;
  var searchValue = "";

  StickyHeaderController controller = StickyHeaderController();

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookModel>(context);

    List<String> words() => bookProvider.words[widget.book]!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (words().isEmpty) {
        for (var word in _words) {
          bookProvider.add(widget.book, word);
        }
        words().sort();
      }
    });

    void initWords(Map<String, List<Word>> wordsMap,
        Map<String, Word> wordsMapMain, List<String> words) {
      if (wordsMap.isEmpty) {
        for (String word in words) {
          if (wordsMap[word[0]] == null) {
            wordsMap.putIfAbsent(word[0], () => []);
          }
          wordsMap[word[0]]!.add(
            Word(
              type: Word.verb,
              word: word,
              definitions: ['def1', 'def2'],
              semanticFields: ['sem1', 'sem2'],
              examplePhrases: ['ex1', 'ex2'],
              italianType: Word.literature,
              italianCorrespondence: 'Pog',
              synonyms: ['s1'],
              antonyms: ['a1', 'a2', 'a3'],
            ),
          );
          wordsMapMain.putIfAbsent(
            word,
            () => Word(
              type: Word.verb,
              word: word,
              definitions: ['def1', 'def2'],
              semanticFields: ['sem1', 'sem2'],
              examplePhrases: ['ex1', 'ex2'],
              italianType: Word.literature,
              italianCorrespondence: 'Pog',
              synonyms: ['s1'],
              antonyms: ['a1', 'a2', 'a3'],
            ),
          );
        }
      }
    }

    initWords(_wordsMap, _wordsMapMain, words());

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

    List<Widget> getWordList(List<String> words) {
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
                          word: map[letter]!.elementAt(index),
                          book: widget.book),
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
      return slivers;
    }

    List<Widget> getSearchResult() {
      /// Lists all the contacts that were matched against the search query.
      /// Pretty straightForward. Go through the list and check if substring matches
      /// any contacts
      List<String> wordsSearched = [];

      for (var word in words()) {
        if (!word.toLowerCase().contains(searchValue)) {
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
          onRefresh: () => Future(() {}),
          builder: SpinnerRefreshUtil.buildSpinnerOnlyRefreshIndicator,
        ),
        searchSliver,
        MultiSliver(children: getWordsList()),
      ],
    );
  }
}
