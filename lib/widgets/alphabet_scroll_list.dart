import 'dart:collection';

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
    "Giaco",
    "Lenzo",
    "Zorro",
    "Zorro1",
    "Zorr2",
    "Zorr3"
  ];

  final wordsWidget = [];

  @override
  Widget build(BuildContext context) {
    words.sort((a, b) {
      return a.compareTo(b);
    });

    /// This variable holds the positions in the ListView. We need that to implement
    /// the functionality of the direct jump to the given letter in the list
    Map<String, double> _letterPositions = {};

    /// Scroll controller is used to well... scroll to the given positions
    ScrollController _scrollController = new ScrollController();

    /// If we are filtering list by names, we change the layout of widget. These
    /// two variables state whether we are in the search state right now and if we a
    /// are, what searchValue tells what we are looking for.
    bool _inSearchState = false;
    late String _searchValue;

    List<Widget> getStartingLetters() {
      /// This functions goes through all contacts details and finds all starting
      /// letters of the names in the list. They are later used to implement quick
      /// jump to the letter functionality
      if (_inSearchState) {
        /// When we are in the search state we do not need to display that column
        return [];
      }

      /// For simplicity, use set to keep unique letter
      Set<String> out_set = Set();
      for (String pc in words) {
        out_set.add(pc[0]);
      }

      /// We then need to sort that letters in the alphabetical order
      var out_list = out_set.toList();
      out_list.sort();

      /// Now we just build a list of children for the small Column on the right
      /// hand side
      List<Widget> out = [];
      for (var l in out_list) {
        out.add(ButtonWidget(
          onPressed: () {
            _scrollController.jumpTo(
              _letterPositions[l]!,
            );
          },
          text: l,
          backgroundColor: CupertinoColors.systemRed,
        ));
      }
      return out;
    }

    List<Widget> getContactList() {
      List<Widget> out = [];
      SplayTreeMap<String, Set<String>> groupedContacts = SplayTreeMap();

      for (String pc in words) {
        if (!groupedContacts.containsKey(pc[0])) {
          /// If a key is missing, add it
          groupedContacts[pc[0]] = Set<String>();
        }

        /// Then add a name as well
        groupedContacts[pc[0]]!.add(pc);
      }

      /// totalShift is used for quick jump to letter functionality. For a jump we
      /// need to know total height of a jump in pixels. We know how much space
      /// each row occupies, therefore we can pre-calculate positions of all letters
      double totalShift = 0;
      groupedContacts.forEach((k, v) {
        /// Iterating through all key-value pairs, init jump height with 0
        _letterPositions[k] = 0;
        out.add(
          Container(
            height: 50,
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                k,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        int l = v.length;
        int ct = 0;

        /// Init jump height we total running height accumulated so far
        _letterPositions[k] = totalShift;

        /// Increase jump height by the known height of a Letter row
        totalShift += 50;

        for (String name in v) {
          /// Increase jump height by the know height of a name row
          totalShift += 50;
          out.add(SizedBox(
            height: 50,
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
            out.add(DividerWidget());
            totalShift += 16;
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
        if (!name.toLowerCase().contains(_searchValue)) {
          continue;
        }
        if (out.isEmpty) {
          /// We only need to add Top Search Results string iff we found anything
          /// Otherwise iOS leaves it empty
          out.add(Container(
            color: Colors.grey.shade300,
            height: 50,
            child: const Text(
              "Top search results",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ));
          out.add(DividerWidget());
        }
        out.add(SizedBox(
          height: 50,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ));
        out.add(DividerWidget());
      }
      return out;
    }

    List<Widget> getContactListMaster() {
      /// This is small facade for the drawing widgets.
      /// If we are in the search state, we drawn a normal contact list
      /// Otherwise we are drawing search results widgets
      if (!_inSearchState) {
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
            flex: 3,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SearchTextField(
                    onChanged: (searchValue) {
                      setState(() {
                        _inSearchState = searchValue.isNotEmpty;
                        _searchValue = searchValue.toLowerCase();
                      });
                    },
                    // decoration: InputDecoration(
                    //   border: new OutlineInputBorder(
                    //     borderRadius: const BorderRadius.all(
                    //       const Radius.circular(10.0),
                    //     ),
                    //   ),
                    //   hintText: "Search",
                    //   fillColor: Colors.grey,
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 13,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 30,
                  child: ListView(
                    controller: _scrollController,
                    children: getContactListMaster(),
                  ),
                ),
                Expanded(
                  flex: 1,
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
