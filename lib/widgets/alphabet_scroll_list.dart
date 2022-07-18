import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/container_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AlphabetScrollList extends StatelessWidget {
  final String repo;

  AlphabetScrollList(this.repo, {Key? key}) : super(key: key);

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
    var map = _buildMap(words);
    for (var word in words) {
      wordsWidget.add(Text(word));
    }
    return RefreshIndicator(
      color: Colors.greenAccent,
      onRefresh: () async {},
      child: AlphabetListScrollView(
        strList: words,
        showPreview: true,
        keyboardUsage: true,
        normalTextStyle: const TextStyle(
          color: CupertinoColors.systemGrey,
          fontWeight: FontWeight.bold,
        ),
        highlightTextStyle: TextStyle(
          color: Theme.of(context).platform == TargetPlatform.android
              ? Theme.of(context).primaryColor
              : CupertinoTheme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        itemBuilder: (context, index) {
          return map[words[index]]!
              ? StaggeredGrid.count(
                  crossAxisCount: 1,
                  children: [
                    Text(
                      words[index].substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.red,
                      ),
                    ),
                    Padding(
                      padding: Constants.padding,
                      child: StaggeredGrid.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(words[index])),
                        ],
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: Constants.padding,
                  child: StaggeredGrid.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(words[index])),
                    ],
                  ),
                );
        },
        indexedHeight: (int i) => map[words[i]]! ? 80 : 50,
      ),
    );
  }

  Map<String, bool> _buildMap(List<String> words) {
    List<String> bools = [];
    Map<String, bool> wordsMap = {};

    for (var word in words) {
      if (!bools.contains(word.substring(0, 1).toUpperCase())) {
        bools.add(word.substring(0, 1));
        wordsMap.putIfAbsent(word, () => true);
      } else {
        wordsMap.putIfAbsent(word, () => false);
      }
    }
    return wordsMap;
  }
}
