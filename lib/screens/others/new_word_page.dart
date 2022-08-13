import 'dart:developer';

import 'package:app_word/models/word.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:app_word/widgets/global/tab_bar_widget.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:app_word/widgets/global/text_field_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddWordPage extends StatefulWidget {
  static const route = "/add_word";

  final Word? word;

  const AddWordPage({
    Key? key,
    this.word,
  }) : super(key: key);

  @override
  State<AddWordPage> createState() => _AddWordPageState();
}

class _AddWordPageState extends State<AddWordPage> {
  String wordsBook = Constants.personalBook;

  String selectedValue = Word.verb;

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

  List<Text> getTipologies() {
    List<Text> list = [];
    for (var item in tipologies) {
      list.add(Text(item));
    }
    return list;
  }

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
    return PageScaffold(
      title: widget.word != null ? "Modifica vocabolo" : "Aggiungi vocabolo",
      scrollable: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: StaggeredGrid.count(
          crossAxisCount: 1,
          children: [
            StaggeredGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 14,
              children: [
                TabBarWidget(
                  tabs: const [Word.verb, Word.noun, Word.other],
                  padding: 0,
                  onValueChanged: (value) {
                    setState(() {
                      if (widget.word == null) {
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
                      }
                    });
                  },
                ),
                Visibility(
                  visible: selectedValue == Word.other ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Tipologia: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedTipology != null
                                ? tipologies.elementAt(selectedTipology!)
                                : "",
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
                            onPressed: () => Theme.of(context).platform ==
                                    TargetPlatform.iOS
                                ? showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _buildBottomPicker(
                                          CupertinoPicker(
                                            itemExtent: 30,
                                            scrollController:
                                                FixedExtentScrollController(
                                                    initialItem:
                                                        selectedTipology != null
                                                            ? selectedTipology!
                                                            : 1),
                                            onSelectedItemChanged: (index) {
                                              setState(() {
                                                selectedTipology = index;
                                                word.tipology =
                                                    tipologies.elementAt(
                                                        selectedTipology!);
                                              });
                                            },
                                            children: getTipologies(),
                                          ),
                                          context);
                                    },
                                  )
                                : {},
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
                  onChanged: (value) => word.word = value,
                  text: widget.word != null ? word.word : null,
                ),
                Visibility(
                  visible: selectedValue == "Sostantivo" ? true : false,
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
                  separator: null,
                  controller: definitionController,
                  icon: CupertinoIcons.text_justify,
                  initialTags:
                      widget.word != null ? widget.word!.definitions : null,
                ),
                TextFieldTagsWidget(
                  errorPhrase: "Campo semantico già inserito",
                  insertPhrase: "Inserisci campo semantico",
                  separator: null,
                  controller: semanticFieldController,
                  icon: CupertinoIcons.textbox,
                  initialTags:
                      widget.word != null ? widget.word!.semanticFields : null,
                ),
                TextFieldTagsWidget(
                  errorPhrase: "Frase già inserita!",
                  insertPhrase: "Inserire una frase",
                  separator: null,
                  controller: phraseController,
                  icon: CupertinoIcons.text_quote,
                  initialTags:
                      widget.word != null ? widget.word!.examplePhrases : null,
                ),
                Visibility(
                  visible: true, //selectedValue != "Altro" ? true : false,
                  child: StaggeredGrid.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 15,
                    children: [
                      TextFieldTagsWidget(
                        errorPhrase: "Sinonimo già inserito!",
                        insertPhrase: "Inserire un sinonimo",
                        separator: " ",
                        controller: synController,
                        icon: CupertinoIcons.sun_max,
                        initialTags:
                            widget.word != null ? widget.word!.synonyms : null,
                      ),
                      TextFieldTagsWidget(
                        errorPhrase: "Contrario già inserito!",
                        insertPhrase: "Inseriro un contrario",
                        separator: " ",
                        controller: antController,
                        icon: CupertinoIcons.moon,
                        initialTags:
                            widget.word != null ? widget.word!.antonyms : null,
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
                        word.italianCorrespondence = itaValue;
                      });
                    }),
                Visibility(
                  visible: itaValue == Word.literature ? true : false,
                  child: TextFieldWidget(
                      placeholder: "Corrispondenza italiano moderno",
                      maxLines: 1,
                      icon: CupertinoIcons.text_cursor,
                      onChanged: (value) => word.italianCorrespondence = value,
                      text: widget.word != null
                          ? word.italianCorrespondence
                          : null),
                ),
                const SizedBox(height: 10),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: widget.word != null ? "Aggiorna parola" : "Aggiungi",
                    onPressed: () async {
                      word.definitions.clear();
                      word.semanticFields.clear();
                      word.synonyms.clear();
                      word.antonyms.clear();
                      word.examplePhrases.clear();

                      if (definitionController.getTags != null) {
                        for (var def in definitionController.getTags!) {
                          word.definitions.add(def);
                        }
                      }
                      if (semanticFieldController.getTags != null) {
                        for (var sem in semanticFieldController.getTags!) {
                          word.semanticFields.add(sem);
                        }
                      }
                      if (phraseController.getTags != null) {
                        for (var phrase in phraseController.getTags!) {
                          word.examplePhrases.add(phrase);
                        }
                      }
                      if (synController.getTags != null) {
                        for (var syn in synController.getTags!) {
                          word.synonyms.add(syn);
                        }
                      }
                      if (antController.getTags != null) {
                        for (var ant in antController.getTags!) {
                          word.antonyms.add(ant);
                        }
                      }
                      // if (word.word.isEmpty) {
                      //   if (widget.word != null) {
                      //     word.word = widget.word!.word;
                      //   } else {
                      //     showCupertinoDialog(
                      //       context: context,
                      //       builder: (context) => const ErrorDialogWidget(
                      //           "Inserire il vocabolo!"),
                      //     );
                      //   }
                      // } else if (word.definitions!.isEmpty) {
                      //   showCupertinoDialog(
                      //     context: context,
                      //     builder: (context) => const ErrorDialogWidget(
                      //         "Inserire la definizione!"),
                      //   );
                      // } else if (word.semanticFields!.isEmpty) {
                      //   showCupertinoDialog(
                      //     context: context,
                      //     builder: (context) => const ErrorDialogWidget(
                      //         "Inserire il campo semantico!"),
                      //   );
                      // } else if (word.italianType == Word.literature &&
                      //     word.italianCorrespondence!.isEmpty) {
                      //   showCupertinoDialog(
                      //     context: context,
                      //     builder: (context) => const ErrorDialogWidget(
                      //         "Inserire il termine in italiano moderno!"),
                      //   );
                      // } else {
                      //   showCupertinoDialog(
                      //     context: context,
                      //     builder: (context) => const LoadingWidget(),
                      //   );

                      // if (widget.word != null) {
                      //   if (word.word!.isEmpty) {
                      //     word.word = widget.word!.word!;
                      //     if (word.italianCorrespondence!.isEmpty) {
                      //       word.italianCorrespondence =
                      //           widget.word!.italianCorrespondence!;
                      //     }
                      //   }
                      //   log("1_ Word to edit: " + word.toString());
                      //   await FirestoreRepository.updateWord(
                      //       word, model.selectedBook);
                      //   log("3_ Word updated");
                      // } else {
                      //   if (model.dailyWord) {
                      //     model.setDailyWord(false);
                      //     log("1_ Word to add: " + word.toString());
                      //     await FirestoreRepository.addDailyWord(word);
                      //     log("3_ Word added");
                      //   } else {
                      //     log("1_ Word to add: " + word.toString());
                      //     await FirestoreRepository.addWord(
                      //         word, model.selectedBook);
                      //     log("3_ Word added");
                      //   }
                      // }
                      //Navigator.pop(context);
                      //Navigator.pop(context);
                      //}
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker, BuildContext context) {
    return Container(
      height: 150,
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 6.0),
      child: picker,
    );
  }
}
