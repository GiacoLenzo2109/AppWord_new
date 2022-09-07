import 'dart:developer';

import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/database/repository/daily_word_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/word/word_page.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/theme/theme_provider.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/global_func.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/bottom_picker.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/tab_bar_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:app_word/widgets/global/text_field_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddWordPage extends StatefulWidget {
  final Word? word;
  final bool? isDailyWord;
  final bool? isAdmin;

  const AddWordPage({
    Key? key,
    this.word,
    this.isDailyWord,
    this.isAdmin,
  }) : super(key: key);

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  String wordsBook = Constants.personalBook;

  String selectedValue = Word.verb;

  List<String> values = [Word.verb, Word.noun, Word.other];

  String genderValue = Word.male;

  String multeplicityValue = Word.singular;

  String itaValue = Word.modern;

  bool definitionsLoaded = false;
  bool semanticFieldsLoaded = false;
  bool synLoaded = false;
  bool antLoaded = false;
  bool phrasesLoaded = false;

  int? selectedTipology;
  List<String> tipologies = [
    "Locuzione",
    "Avverbio",
    "Pronome",
    "Preposizione"
  ];

  TextfieldTagsController synController = TextfieldTagsController(),
      antController = TextfieldTagsController(),
      phraseController = TextfieldTagsController(),
      definitionController = TextfieldTagsController(),
      semanticFieldController = TextfieldTagsController();

  Word word = Word();

  @override
  void initState() {
    if (widget.word != null) {
      word = widget.word!;

      selectedValue = word.type.isNotEmpty ? word.type : Word.verb;

      selectedTipology =
          word.tipology.isNotEmpty ? tipologies.indexOf(word.tipology) : null;

      genderValue = word.gender.isNotEmpty ? word.gender : Word.male;

      multeplicityValue = widget.word!.multeplicity.isNotEmpty
          ? word.multeplicity
          : Word.singular;

      itaValue = word.italianType.isNotEmpty ? word.italianType : Word.modern;
    }

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 0)).then((value) {
        if (definitionController.getTags != null) {
          if (!definitionsLoaded) {
            for (var tag in word.definitions) {
              definitionController.onSubmitted(tag);
            }
          }
          definitionsLoaded = true;
          definitionController.onTagDelete("");
        }
        if (semanticFieldController.getTags != null) {
          if (!semanticFieldsLoaded) {
            for (var tag in word.semanticFields) {
              semanticFieldController.onSubmitted(tag);
            }
          }
          semanticFieldsLoaded = true;
          semanticFieldController.onTagDelete("");
        }
        if (synController.getTags != null) {
          if (!synLoaded) {
            for (var tag in word.synonyms) {
              synController.onSubmitted(tag);
            }
          }
          synLoaded = true;
          synController.onTagDelete("");
        }
        if (antController.getTags != null) {
          if (!antLoaded) {
            for (var tag in word.antonyms) {
              antController.onSubmitted(tag);
            }
          }
          antLoaded = true;
          antController.onTagDelete("");
        }
        if (phraseController.getTags != null) {
          if (!phrasesLoaded) {
            for (var tag in word.examplePhrases) {
              phraseController.onSubmitted(tag);
            }
          }
          phrasesLoaded = true;
          phraseController.onTagDelete("");
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDailyWord =
        widget.isDailyWord != null && widget.isDailyWord! ? true : false;
    final bookProvider = Provider.of<BookModel>(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return SimplePageScaffold(
      title: widget.word != null
          ? "Modifica vocabolo"
          : isDailyWord
              ? "Aggiungi vocabolo del giorno"
              : "Aggiungi vocabolo",
      padding: 0,
      scrollable: true,
      // backgroundColor: themeProvider.isDarkTheme
      //     ? null
      //     : ThemesUtil.getPrimaryColor(context),
      titleColor: Colors.white,
      isFullScreen: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          children: [
            TabBarWidget(
              tabs: const [Word.verb, Word.noun, Word.other],
              padding: ThemesUtil.isAndroid(context) ? 0 : 10,
              initialValue: values.indexOf(selectedValue),
              onValueChanged: (value) {
                setState(() {
                  switch (value) {
                    case 0:
                      selectedValue = Word.verb;
                      break;
                    case 1:
                      selectedValue = Word.noun;
                      break;
                    case 2:
                      selectedValue = Word.other;
                      break;
                  }
                  switch (selectedValue) {
                    case Word.noun:
                      word.gender = Word.male;
                      word.multeplicity = Word.singular;
                      break;
                    case Word.other:
                      word.tipology = tipologies.first;
                      selectedTipology = 0;
                      break;
                    default:
                      word.gender = "";
                      word.multeplicity = "";
                      word.tipology = '';
                  }
                  word.type = selectedValue;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: StaggeredGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 14,
                children: [
                  Visibility(
                    visible: selectedValue == Word.other,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Tipologia: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              selectedTipology != null
                                  ? tipologies.elementAt(selectedTipology!)
                                  : "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil.getSize(context).height / 55,
                        ),
                        StaggeredGrid.count(
                          crossAxisCount: 1,
                          children: [
                            ButtonWidget(
                              backgroundColor: CupertinoColors.activeOrange,
                              text: "Scegliere tipologia",
                              onPressed: () => DialogUtil.showModalPopupSheet(
                                context: context,
                                builder: (context) => BottomPickerWidget(
                                  onSelect: (index) {
                                    setState(() {
                                      selectedTipology = index;
                                      word.tipology = tipologies
                                          .elementAt(selectedTipology!);
                                    });
                                  },
                                  title: 'Scegli la tipologia',
                                  items: tipologies,
                                  initialItem: selectedTipology ?? 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextFieldWidget(
                    placeholder: "Inserisci vocabolo",
                    icon: CupertinoIcons.text_cursor,
                    maxLines: 1,
                    onChanged: (value) =>
                        word.word = GlobalFunc.capitalize(value),
                    text: widget.word != null ? word.word : null,
                  ),
                  Visibility(
                    visible: selectedValue == "Sostantivo",
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      children: [
                        CupertinoSlidingSegmentedControl(
                            groupValue: genderValue,
                            children: const {
                              Word.male: Text("M"),
                              Word.female: Text("F"),
                            },
                            onValueChanged: (String? index) {
                              setState(() {
                                genderValue = index!;
                                word.gender = genderValue;
                              });
                            }),
                        CupertinoSlidingSegmentedControl(
                            groupValue: multeplicityValue,
                            children: const {
                              Word.singular: Text("S"),
                              Word.plural: Text("P"),
                            },
                            onValueChanged: (String? index) {
                              setState(() {
                                multeplicityValue = index!;
                                word.multeplicity = multeplicityValue;
                              });
                            }),
                      ],
                    ),
                  ),
                  TextFieldTagsWidget(
                    errorPhrase: "Definizione già inserita",
                    insertPhrase: "Inserisci definizione",
                    separator: const [""],
                    controller: definitionController,
                    icon: CupertinoIcons.text_justify,
                    initialTags:
                        widget.word != null ? widget.word!.definitions : null,
                    expands: true,
                  ),
                  TextFieldTagsWidget(
                    errorPhrase: "Campo semantico già inserito",
                    insertPhrase: "Inserisci campo semantico",
                    separator: const [""],
                    controller: semanticFieldController,
                    icon: CupertinoIcons.textbox,
                    initialTags: widget.word != null
                        ? widget.word!.semanticFields
                        : null,
                  ),
                  TextFieldTagsWidget(
                    errorPhrase: "Frase già inserita!",
                    insertPhrase: "Inserire una frase",
                    separator: const [""],
                    expands: true,
                    controller: phraseController,
                    icon: CupertinoIcons.text_quote,
                    initialTags: widget.word != null
                        ? widget.word!.examplePhrases
                        : null,
                  ),
                  Visibility(
                    visible: true, //selectedValue != "Altro",
                    child: StaggeredGrid.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 15,
                      children: [
                        TextFieldTagsWidget(
                          errorPhrase: "Sinonimo già inserito!",
                          insertPhrase: "Inserire un sinonimo",
                          controller: synController,
                          icon: CupertinoIcons.sun_max,
                          initialTags: widget.word != null
                              ? widget.word!.synonyms
                              : null,
                        ),
                        TextFieldTagsWidget(
                          errorPhrase: "Contrario già inserito!",
                          insertPhrase: "Inseriro un contrario",
                          controller: antController,
                          icon: CupertinoIcons.moon,
                          initialTags: widget.word != null
                              ? widget.word!.antonyms
                              : null,
                        ),
                      ],
                    ),
                  ),
                  CupertinoSlidingSegmentedControl(
                      groupValue: itaValue,
                      children: const {
                        Word.modern: Text("Ita moderno"),
                        Word.literature: Text("Ita letteratura"),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          itaValue = value as String;
                          word.italianType = value;

                          if (word.italianType == Word.literature) {
                            word.italianCorrespondence = GlobalFunc.capitalize(
                                word.italianCorrespondence);
                          }
                        });
                      }),
                  Visibility(
                    visible: itaValue == Word.literature,
                    child: TextFieldWidget(
                        placeholder: "Corrispondenza italiano moderno",
                        maxLines: 1,
                        icon: CupertinoIcons.text_cursor,
                        onChanged: (value) {
                          word.italianCorrespondence =
                              GlobalFunc.capitalize(value);
                        },
                        text: widget.word != null &&
                                word.italianCorrespondence.isNotEmpty
                            ? word.italianCorrespondence
                            : null),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: //Expanded(
                  ButtonWidget(
                text: widget.word != null ? "Aggiorna parola" : "Aggiungi",
                onPressed: () async {
                  word.definitions.clear();
                  word.semanticFields.clear();
                  word.synonyms.clear();
                  word.antonyms.clear();
                  word.examplePhrases.clear();

                  if (definitionController.getTags != null) {
                    for (var def in definitionController.getTags!) {
                      word.definitions.add(GlobalFunc.capitalize(def));
                    }
                  }
                  if (semanticFieldController.getTags != null) {
                    for (var sem in semanticFieldController.getTags!) {
                      word.semanticFields.add(GlobalFunc.capitalize(sem));
                    }
                  }
                  if (phraseController.getTags != null) {
                    for (var phrase in phraseController.getTags!) {
                      word.examplePhrases.add(GlobalFunc.capitalize(phrase));
                    }
                  }
                  if (synController.getTags != null) {
                    for (var syn in synController.getTags!) {
                      word.synonyms.add(GlobalFunc.capitalize(syn));
                    }
                  }
                  if (antController.getTags != null) {
                    for (var ant in antController.getTags!) {
                      word.antonyms.add(GlobalFunc.capitalize(ant));
                    }
                  }
                  if (word.word.isEmpty) {
                    if (widget.word != null) {
                      word.word = GlobalFunc.capitalize(widget.word!.word);
                    } else {
                      DialogUtil.openDialog(
                        context: context,
                        builder: (context) =>
                            const ErrorDialogWidget("Inserire il vocabolo!"),
                      );
                    }
                  } else if (word.definitions.isEmpty) {
                    DialogUtil.openDialog(
                      context: context,
                      builder: (context) =>
                          const ErrorDialogWidget("Inserire la definizione!"),
                    );
                  } else if (word.semanticFields.isEmpty) {
                    DialogUtil.openDialog(
                      context: context,
                      builder: (context) => const ErrorDialogWidget(
                          "Inserire il campo semantico!"),
                    );
                  } else if (word.italianType == Word.literature &&
                      word.italianCorrespondence.isEmpty) {
                    DialogUtil.openDialog(
                      context: context,
                      builder: (context) => const ErrorDialogWidget(
                          "Inserire il termine in italiano moderno!"),
                    );
                  } else {
                    if (widget.word != null) {
                      if (word.word.isEmpty) {
                        word.word = widget.word!.word;
                        if (word.italianCorrespondence.isEmpty) {
                          word.italianCorrespondence =
                              widget.word!.italianCorrespondence;
                        }
                      }
                      log("1. Word to edit: $word");
                      if (isDailyWord) {
                        log("1_ Word to add: $word");
                        await DailyWordRepository.updateDailyWord(
                          context: context,
                          dailyWord: word,
                        ).whenComplete(
                          () {
                            bookProvider.updateWord(word);
                            Navigator.pop(context);
                          },
                        );
                        log("2. Word updated");
                      } else {
                        await BookRepository.updateWord(
                                context: context,
                                bookId: bookProvider.id,
                                word: word)
                            .whenComplete(
                          () {
                            bookProvider.updateWord(word);
                            Navigator.pop(context);
                          },
                        );
                      }
                    } else {
                      if (isDailyWord) {
                        log("1_ Word to add: $word");
                        await DailyWordRepository.addDailyWord(
                          context: context,
                          dailyWord: word,
                        ).whenComplete(
                          () {
                            Navigator.pop(context);
                          },
                        );
                        log("3_ Word added");
                      } else {
                        log("1. Word to add: $word");
                        if (!bookProvider.isWordCreated(word.word)) {
                          await BookRepository.addWordToBook(
                                  context: context,
                                  bookId: bookProvider.id,
                                  word: word)
                              .then(
                            (word) {
                              bookProvider.addWord(word);
                              NavigatorUtil.navigatePopGo(
                                context: context,
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: bookProvider,
                                  child: ThemesUtil.isAndroid(context)
                                      ? WordPage(word: word)
                                      : CupertinoScaffold(
                                          body: WordPage(word: word),
                                        ),
                                ),
                              );
                            },
                          );
                        } else {
                          DialogUtil.openDialog(
                            context: context,
                            builder: (context) => const ErrorDialogWidget(
                                "Vocabolo già esistente!"),
                          );
                        }
                        log("2. Word added!");
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
