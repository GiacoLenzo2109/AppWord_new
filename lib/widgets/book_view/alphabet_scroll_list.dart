import 'dart:collection';
import 'dart:developer';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/container_widget.dart';
import 'package:app_word/widgets/global/divider_widget.dart';
import 'package:app_word/widgets/global/search_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class AlphabetScrollList extends StatefulWidget {
  final String book;

  const AlphabetScrollList(this.book, {Key? key}) : super(key: key);

  @override
  State<AlphabetScrollList> createState() => _AlphabetScrollListState();
}

class _AlphabetScrollListState extends State<AlphabetScrollList> {
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

  final Map<String, Word> _wordsMap = {};

  final double jumpShiftLetter = 25;
  final double jumpShiftWord = 50;

  var selectedLetter = "A";

  bool searching = false;
  var searchValue = "";

  @override
  void initState() {
    if (_wordsMap.isEmpty) {
      for (String word in _words) {
        _wordsMap.putIfAbsent(
          word,
          () => Word(
            type: Word.verb,
            word: word,
            definitions: ['def1', 'def2'],
            semanticFields: ['sem1', 'sem2'],
            examplePhrases: ['ex1', 'ex2'],
            italianType: Word.literature,
            synonyms: ['s1'],
            antonyms: ['a1', 'a2', 'a3'],
          ),
        );
      }
    }
    super.initState();
  }

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

    /// This variable holds the positions in the ListView. We need that to implement
    /// the functionality of the direct jump to the given letter in the list
    Map<String, double> letterPositions = {};

    /// Scroll controller is used to well... scroll to the given positions
    ScrollController scrollController = ScrollController();

    List<Widget> getStartingLetters() {
      /// This functions goes through all contacts details and finds all starting
      /// letters of the names in the list. They are later used to implement quick
      /// jump to the letter functionality

      /// For simplicity, use set to keep unique letter
      Set<String> outSet = {};
      for (String pc in words()) {
        outSet.add(pc[0]);
      }

      /// We then need to sort that letters in the alphabetical order
      var outList = outSet.toList();
      outList.sort();

      Widget buildLetterButton(Function() onPressed, String letter) {
        return GestureDetector(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: selectedLetter == letter ? Colors.red : Colors.transparent,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
              child: Text(
                letter,
                style: ThemesUtil.titleContainerStyle(context).copyWith(
                  color: selectedLetter != letter
                      ? ThemesUtil.getTextColor(context)
                      : Colors.white,
                  fontSize: 15,
                ),
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
              if (selectedLetter != l && !searching) {
                scrollController.animateTo(
                  letterPositions[l]!,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 250),
                );
              }
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

    List<Widget> getWordList() {
      List<Widget> out = [];
      SplayTreeMap<String, Set<String>> wordsMap = SplayTreeMap();

      for (String word in words()) {
        if (!wordsMap.containsKey(word[0])) {
          /// If a key is missing, add it
          wordsMap[word[0]] = <String>{};
        }

        /// Then add a name as well
        wordsMap[word[0]]!.add(word);
      }

      /// totalShift is used for quick jump to letter functionality. For a jump we
      /// need to know total height of a jump in pixels. We know how much space
      /// each row occupies, therefore we can pre-calculate positions of all letters
      double totalShift = 0;
      wordsMap.forEach((k, v) {
        /// Iterating through all key-value pairs, init jump height with 0
        letterPositions[k] = 0;
        out.add(
          SizedBox(
            height: 25,
            child: Text(
              k,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: ThemesUtil.getPrimaryColor(context),
              ),
            ),
          ),
        );
        int l = v.length;
        int ct = 0;

        letterPositions[k] = totalShift;

        /// Increase jump height by the known height of a Letter row
        totalShift += jumpShiftLetter;

        for (String word in v) {
          /// Increase jump height by the know height of a name row
          totalShift += jumpShiftWord;
          out.add(
            WordItem(book: widget.book, word: _wordsMap[word]!),
          );

          /// We just do not want to add a Divider if there are no records left for
          /// this key
          if (ct < l - 1) {
            out.add(const DividerWidget());
            totalShift += 1;
          }
          ct++;
        }
      });
      return out;
    }

    List<Widget> getSearchResult() {
      /// Lists all the contacts that were matched against the search query.
      /// Pretty straightForward. Go through the list and check if substring matches
      /// any contacts
      List<Widget> out = [];

      for (String word in words()) {
        if (!word.toLowerCase().contains(searchValue)) {
          continue;
        }
        if (out.isEmpty) {
          /// We only need to add Top Search Results string iff we found anything
          /// Otherwise iOS leaves it empty
          out.add(SizedBox(
            height: jumpShiftWord,
            child: const Text(
              "Risultati di ricerca:",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ));
          out.add(const DividerWidget());
        }
        out.add(WordItem(book: widget.book, word: _wordsMap[word]!));
        out.add(const DividerWidget());
      }
      return out;
    }

    List<Widget> getWordsList() {
      return searching ? getSearchResult() : getWordList();
    }

    scrollController.addListener(() {
      letterPositions.forEach((key, value) {
        if (scrollController.position.pixels >= value) {
          setState(() {
            selectedLetter = key;
          });
        }
      });
    });

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
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
          Expanded(
            flex: 13,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 28,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    controller: scrollController,
                    children: getWordsList(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getStartingLetters(),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: ThemesUtil.isAndroid(context) ? 25 : 100),
        ],
      ),
    );
  }
}
