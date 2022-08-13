import 'package:app_word/models/word.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/container_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WordPage extends StatelessWidget {
  final Word word;

  const WordPage({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      onRefresh: () async {},
      scrollable: true,
      title: word.word,
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 14,
        children: [
          Text(
            word.type == Word.noun
                ? "${word.type}, ${word.gender}, ${word.multeplicity}"
                : word.type == Word.other
                    ? word.tipology
                    : word.type,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
          ContaienrWidget(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              children: [
                Text(
                  "Definizione:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: CupertinoTheme.of(context).primaryContrastingColor,
                  ),
                ),
                SizedBox(
                  width: ScreenUtil.getSize(context).width,
                  height: (word.definitions.length * 23).toDouble(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemExtent: 23,
                    itemCount: word.definitions.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoTheme.of(context)
                                .primaryContrastingColor,
                          ),
                        ),
                        Text(
                          "${index}. ${word.definitions.elementAt(index)}",
                          style: TextStyle(
                            color: CupertinoTheme.of(context)
                                .primaryContrastingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ContaienrWidget(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              children: [
                Text(
                  "Campo semantico:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: CupertinoTheme.of(context).primaryContrastingColor,
                  ),
                ),
                SizedBox(
                  width: ScreenUtil.getSize(context).width,
                  height: (word.semanticFields.length * 23).toDouble(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemExtent: 23,
                    itemCount: word.semanticFields.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoTheme.of(context)
                                .primaryContrastingColor,
                          ),
                        ),
                        Text(
                          word.semanticFields.elementAt(index),
                          style: TextStyle(
                            color: CupertinoTheme.of(context)
                                .primaryContrastingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: word.examplePhrases.isNotEmpty,
            child: ContaienrWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                children: [
                  Text(
                    "Frasi esempio:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: CupertinoTheme.of(context).primaryContrastingColor,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil.getSize(context).width,
                    height: (word.examplePhrases.length * 23).toDouble(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemExtent: 23,
                      itemCount: word.examplePhrases.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Text(
                            "${index + 1}. ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CupertinoTheme.of(context)
                                  .primaryContrastingColor,
                            ),
                          ),
                          Text(
                            '"${word.examplePhrases.elementAt(index)}"',
                            style: TextStyle(
                              color: CupertinoTheme.of(context)
                                  .primaryContrastingColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: word.synonyms.isNotEmpty || word.antonyms.isNotEmpty,
            child: ContaienrWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                children: [
                  StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      Visibility(
                        visible: word.synonyms.isNotEmpty ? true : false,
                        child: const Text(
                          "Sinonimi:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Visibility(
                        visible: word.synonyms.isNotEmpty ? true : false,
                        child: SizedBox(
                          width: ScreenUtil.getSize(context).width,
                          height: (word.synonyms.length * 23).toDouble(),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemExtent: 23,
                            itemCount: word.synonyms.length,
                            itemBuilder: (context, index) => Text(
                                "${index + 1}. ${word.synonyms.elementAt(index)}"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      Visibility(
                        visible: word.antonyms.isNotEmpty ? true : false,
                        child: const Text(
                          "Contrari:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Visibility(
                        visible: word.antonyms.isNotEmpty ? true : false,
                        child: SizedBox(
                          width: ScreenUtil.getSize(context).width,
                          height: (word.antonyms.length * 23).toDouble(),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemExtent: 23,
                            itemCount: word.antonyms.length,
                            itemBuilder: (context, index) => Text(
                              "${index + 1}. ${word.antonyms.elementAt(index)}",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: word.italianType == Word.literature ? true : false,
            child: ContaienrWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                children: [
                  Text(
                    "Campo semantico:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: CupertinoTheme.of(context).primaryContrastingColor,
                    ),
                  ),
                  const Text("Valore moderno"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
