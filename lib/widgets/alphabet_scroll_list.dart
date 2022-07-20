import 'dart:collection';
import 'dart:developer';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/button_widget.dart';
import 'package:app_word/widgets/container_widget.dart';
import 'package:app_word/widgets/divider_widget.dart';
import 'package:app_word/widgets/search_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AlphabetScrollList extends StatefulWidget {
  final String repo;

  const AlphabetScrollList(this.repo, {Key? key}) : super(key: key);

  @override
  State<AlphabetScrollList> createState() => _AlphabetScrollListState();
}

class _AlphabetScrollListState extends State<AlphabetScrollList> {
  final words = [
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
    "Lenzo",
    "Zorro",
    "Zorro1",
    "Zorr2",
    "Zorr3"
  ];

  final double jumpShift = 27.5;

  var selectedLetter = "A";

  @override
  Widget build(BuildContext context) {
    var wordsList = words.toList();
    wordsList.sort();

    /// This variable holds the positions in the ListView. We need that to implement
    /// the functionality of the direct jump to the given letter in the list
    Map<String, double> letterPositions = {};

    /// Scroll controller is used to well... scroll to the given positions
    ScrollController scrollController = ScrollController();

    /// If we are filtering list by names, we change the layout of widget. These
    /// two variables state whether we are in the search state right now and if we a
    /// are, what searchValue tells what we are looking for.
    bool inSearchState = false;
    late String searchValue = "";

    List<Widget> getStartingLetters() {
      /// This functions goes through all contacts details and finds all starting
      /// letters of the names in the list. They are later used to implement quick
      /// jump to the letter functionality
      if (inSearchState) {
        /// When we are in the search state we do not need to display that column
        return [];
      }

      /// For simplicity, use set to keep unique letter
      Set<String> outSet = {};
      for (String pc in words) {
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
              if (selectedLetter != l) {
                scrollController.jumpTo(
                  letterPositions[l]!,
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

    List<Widget> getContactList() {
      List<Widget> out = [];
      SplayTreeMap<String, Set<String>> wordsMap = SplayTreeMap();

      for (String word in words) {
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
          Text(
            k,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ThemesUtil.getPrimaryColor(context),
            ),
          ),
        );
        int l = v.length;
        int ct = 0;

        /// Init jump height we total running height accumulated so far
        letterPositions[k] = totalShift;

        /// Increase jump height by the known height of a Letter row
        totalShift += jumpShift;

        for (String name in v) {
          /// Increase jump height by the know height of a name row
          totalShift += jumpShift;
          out.add(SizedBox(
            height: jumpShift,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ));

          /// We just do not want to add a Divider if there are no records left for
          /// this key
          if (ct < l - 1) {
            out.add(const DividerWidget());
            totalShift += jumpShift;
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
      for (String name in words) {
        if (!name.toLowerCase().contains(searchValue)) {
          continue;
        }
        if (out.isEmpty) {
          /// We only need to add Top Search Results string iff we found anything
          /// Otherwise iOS leaves it empty
          out.add(Container(
            color: Colors.grey.shade300,
            height: jumpShift,
            child: const Text(
              "Top search results",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ));
          out.add(const DividerWidget());
        }
        out.add(SizedBox(
          height: jumpShift,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ));
        out.add(const DividerWidget());
      }
      return out;
    }

    List<Widget> getWordsList() {
      /// This is small facade for the drawing widgets.
      /// If we are in the search state, we drawn a normal contact list
      /// Otherwise we are drawing search results widgets
      if (!inSearchState) {
        return getContactList();
      }
      return getSearchResult();
    }

    return ContaienrWidget(
      padding: 10,
      margin: 25,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SearchTextField(
              onChanged: (searchValue) {
                setState(() {
                  inSearchState = searchValue.isNotEmpty;
                  searchValue = searchValue.toLowerCase();
                });
              },
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
          )
        ],
      ),
    );
  }
}
