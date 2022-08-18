import 'package:app_word/models/word.dart';
import 'package:app_word/screens/others/new_word_page.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
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
      trailing: Padding(
        padding: EdgeInsets.only(
          right: Theme.of(context).platform == TargetPlatform.android ? 10 : 0,
        ),
        child: GestureDetector(
          child: Icon(
            CupertinoIcons.pencil,
            color: Theme.of(context).platform == TargetPlatform.iOS
                ? CupertinoColors.activeBlue
                : Theme.of(context).appBarTheme.titleTextStyle!.color,
            size: 25,
          ),
          onTap: () {
            DialogUtil.showModalBottomSheet(
              context: context,
              builder: (context) => AddWordPage(word: word),
            );
          },
        ),
      ),
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
              fontSize: 18,
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
                    color: ThemesUtil.getContrastingColor(context),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil.getSize(context).width,
                  height: (word.definitions.length * 23).toDouble(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemExtent: 23,
                    itemCount: word.definitions.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                        Text(
                          "$index. ${word.definitions.elementAt(index)}",
                          style: TextStyle(
                            color: ThemesUtil.getTextColor(context),
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
                    color: ThemesUtil.getTextColor(context),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil.getSize(context).width,
                  height: (word.semanticFields.length * 23).toDouble(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemExtent: 23,
                    itemCount: word.semanticFields.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                        Text(
                          word.semanticFields.elementAt(index),
                          style: TextStyle(
                            color: ThemesUtil.getTextColor(context),
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
                      color: ThemesUtil.getTextColor(context),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil.getSize(context).width,
                    height: (word.examplePhrases.length * 23).toDouble(),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemExtent: 23,
                      itemCount: word.examplePhrases.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Text(
                            "${index + 1}. ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ThemesUtil.getTextColor(context),
                            ),
                          ),
                          Text(
                            '"${word.examplePhrases.elementAt(index)}"',
                            style: TextStyle(
                              color: ThemesUtil.getTextColor(context),
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
                        visible: word.synonyms.isNotEmpty,
                        child: const Text(
                          "Sinonimi:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Visibility(
                        visible: word.synonyms.isNotEmpty,
                        child: SizedBox(
                          width: ScreenUtil.getSize(context).width,
                          height: (word.synonyms.length * 23).toDouble(),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
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
                        visible: word.antonyms.isNotEmpty,
                        child: const Text(
                          "Contrari:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Visibility(
                        visible: word.antonyms.isNotEmpty,
                        child: SizedBox(
                          width: ScreenUtil.getSize(context).width,
                          height: (word.antonyms.length * 23).toDouble(),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
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
            visible: word.italianType == Word.literature,
            child: ContaienrWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                children: [
                  Text(
                    "Corrispondente italiano moderno:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: ThemesUtil.getTextColor(context),
                    ),
                  ),
                  Text(word.italianCorrespondence),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
