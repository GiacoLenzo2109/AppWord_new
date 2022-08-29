import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/database/repository/daily_word_repository.dart';
import 'package:app_word/database/repository/user_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/providers/book_list_model.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/screens/main/book/word/new_word_page.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/container_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WordPage extends StatefulWidget {
  final Word word;
  final bool? isDailyWord;
  final bool? isAdmin;

  const WordPage({
    Key? key,
    required this.word,
    this.isDailyWord,
    this.isAdmin,
  }) : super(key: key);

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late Word word;

  @override
  void initState() {
    word = widget.word;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookModel>(context);
    final bookListProvider = Provider.of<BookListProvider>(context);

    return PageScaffold(
      onRefresh: () async {
        widget.isDailyWord != null && widget.isDailyWord!
            ? bookProvider.updateWord(
                await DailyWordRepository.getWord(
                    context: context, wordId: word.id),
              )
            : bookProvider.updateWord(
                await BookRepository.getWord(
                    context: context, bookId: bookProvider.id, wordId: word.id),
              );
      },
      scrollable: true,
      title: widget.word.word,
      trailing: Padding(
        padding: EdgeInsets.only(
          right: Theme.of(context).platform == TargetPlatform.android ? 10 : 0,
        ),
        child: GestureDetector(
          child: Icon(
            widget.isDailyWord != null &&
                    widget.isDailyWord! &&
                    widget.isAdmin != null &&
                    !widget.isAdmin!
                ? CupertinoIcons.add
                : CupertinoIcons.pencil,
            color: !ThemesUtil.isAndroid(context)
                ? CupertinoColors.activeBlue
                : Theme.of(context).appBarTheme.titleTextStyle!.color,
            size: 25,
          ),
          onTap: () => DialogUtil.showModalBottomSheet(
            context: context,
            builder: (context) => ChangeNotifierProvider.value(
              value: bookProvider,
              child: widget.isDailyWord != null &&
                      widget.isDailyWord! &&
                      widget.isAdmin != null &&
                      !widget.isAdmin!
                  ? SimplePageScaffold(
                      scrollable: true,
                      title: "Dove vuoi aggiungere il vocabolo?",
                      body: StaggeredGrid.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 15,
                        children: [
                          for (Book book in bookListProvider.books)
                            ButtonWidget(
                              text: book.name,
                              backgroundColor: ThemesUtil.isAndroid(context)
                                  ? Theme.of(context).backgroundColor
                                  : CupertinoThemes.backgroundColor(context),
                              textColor: ThemesUtil.getTextColor(context),
                              onPressed: () {
                                BookRepository.addWordToBook(
                                        context: context,
                                        bookId: book.id,
                                        word: word)
                                    .then(
                                  (word) {
                                    if (word.id.isNotEmpty) {
                                      bookListProvider
                                          .getBookProvider(book.id)
                                          .addWord(word);
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              },
                            )
                        ],
                      ),
                    )
                  : AddWordPage(
                      word: widget.word,
                      isDailyWord: widget.isDailyWord,
                    ),
            ),
          ),
        ),
      ),
      child: StaggeredGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 14,
        children: [
          Text(
            widget.word.type == Word.noun
                ? "${widget.word.type}, ${widget.word.gender}, ${widget.word.multeplicity}"
                : widget.word.type == Word.other
                    ? widget.word.tipology
                    : widget.word.type,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontStyle: FontStyle.italic,
              fontSize: 18,
            ),
          ),
          ContainerWidget(
            child: StaggeredGrid.count(
              crossAxisCount: 1,
              children: [
                SizedBox(
                  width: ScreenUtil.getSize(context).width - 107.5,
                  child: Text(
                    "Definizione:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: ThemesUtil.getContrastingColor(context),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  //itemExtent: 23,
                  itemCount: widget.word.definitions.length,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemesUtil.getTextColor(context),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil.getSize(context).width - 125,
                        child: Text(
                          widget.word.definitions.elementAt(index),
                          style: TextStyle(
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ContainerWidget(
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: widget.word.semanticFields.length,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemesUtil.getTextColor(context),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil.getSize(context).width - 125,
                        child: Text(
                          widget.word.semanticFields.elementAt(index),
                          style: TextStyle(
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.word.examplePhrases.isNotEmpty,
            child: ContainerWidget(
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
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: widget.word.examplePhrases.length,
                    itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemesUtil.getTextColor(context),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil.getSize(context).width - 125,
                          child: Text(
                            '"${widget.word.examplePhrases.elementAt(index)}"',
                            style: TextStyle(
                              color: ThemesUtil.getTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.word.synonyms.isNotEmpty ||
                widget.word.antonyms.isNotEmpty,
            child: ContainerWidget(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                children: [
                  StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      Visibility(
                        visible: widget.word.synonyms.isNotEmpty,
                        child: const Text(
                          "Sinonimi:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Visibility(
                        visible: widget.word.synonyms.isNotEmpty,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: widget.word.synonyms.length,
                          itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemesUtil.getTextColor(context),
                                ),
                              ),
                              SizedBox(
                                width:
                                    ScreenUtil.getSize(context).width / 2 - 75,
                                child: Text(
                                  '"${widget.word.synonyms.elementAt(index)}"',
                                  style: TextStyle(
                                    color: ThemesUtil.getTextColor(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 1,
                    children: [
                      Visibility(
                        visible: widget.word.antonyms.isNotEmpty,
                        child: const Text(
                          "Contrari:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Visibility(
                        visible: widget.word.antonyms.isNotEmpty,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: widget.word.antonyms.length,
                          itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ThemesUtil.getTextColor(context),
                                ),
                              ),
                              SizedBox(
                                width:
                                    ScreenUtil.getSize(context).width / 2 - 75,
                                child: Text(
                                  '"${widget.word.antonyms.elementAt(index)}"',
                                  style: TextStyle(
                                    color: ThemesUtil.getTextColor(context),
                                  ),
                                ),
                              ),
                            ],
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
            visible: widget.word.italianType == Word.literature,
            child: ContainerWidget(
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
                  SizedBox(
                    width: ScreenUtil.getSize(context).width - 125,
                    child: Text(widget.word.italianCorrespondence),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
