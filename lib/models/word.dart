import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Word {
  static const modern = "Ita moderno";
  static const literature = "Ita letteratura";

  static const verb = "Verbo";
  static const noun = "Sostantivo";
  static const other = "Altro";

  static const singular = "Singolare";
  static const plural = "Plurale";
  static const male = "Maschile";
  static const female = "Femminile";

  static const AUTHOR = "Author";
  String author;

  static const ID = "Id";
  String id;

  static const TYPE = "Type";
  String type;

  static const WORD = "Word";
  String word;

  static const TIMESTAMP = "Timestamp";
  Timestamp timestamp;

  static const DEFINITION = "Definitions";
  List<String> definitions;

  static const SEMANTIC_FIELD = "Semantic_field";
  List<String> semanticFields;

  static const EXAMPLE_PHRASES = "Example_phrases";
  List<String> examplePhrases;

  static const SYNONYMS = "Synonims";
  List<String> synonyms;

  static const ANTONYMS = "Antonyms";
  List<String> antonyms;

  static const GENDER = "Gender";
  String gender;

  static const MULTEPLICITY = "Multeplicity";
  String multeplicity;

  static const TIPOLOGY = "Tipology";
  String tipology;

  static const ITALIAN_TYPE = "Italian_type";
  String italianType;

  static const ITALIAN_CORRESPONDENCE = "Italian_correspondence";
  String italianCorrespondence;

  Word(
      {String? author,
      String? id,
      String? type,
      String? word,
      List<String>? definitions,
      List<String>? semanticFields,
      List<String>? examplePhrases,
      Timestamp? timestamp,
      String? italianType,
      String? italianCorrespondence,
      List<String>? synonyms,
      List<String>? antonyms,
      String? tipology,
      String? gender,
      String? multeplicity})
      : author = author ?? "",
        id = id ?? "",
        type = type ?? "Verbo",
        word = word ?? "",
        timestamp = timestamp ?? Timestamp.now(),
        definitions = definitions ?? [],
        semanticFields = semanticFields ?? [],
        examplePhrases = examplePhrases ?? [],
        italianType = italianType ?? Word.modern,
        italianCorrespondence = italianCorrespondence ?? "",
        synonyms = synonyms ?? [],
        antonyms = antonyms ?? [],
        tipology = tipology ?? "",
        gender = gender ?? "",
        multeplicity = multeplicity ?? "";

  factory Word.fromFirestore(Map<String, dynamic> doc) => Word(
        id: doc[ID],
        type: doc[TYPE],
        word: doc[WORD],
        timestamp: doc[TIMESTAMP],
        definitions: doc[DEFINITION],
        semanticFields: doc[SEMANTIC_FIELD],
        examplePhrases: doc[EXAMPLE_PHRASES],
        italianType: doc[ITALIAN_TYPE],
        italianCorrespondence: doc[ITALIAN_CORRESPONDENCE],
        synonyms: doc[SYNONYMS],
        antonyms: doc[ANTONYMS],
        tipology: doc[TIPOLOGY],
        gender: doc[GENDER],
        multeplicity: doc[MULTEPLICITY],
      );

  Map<String, dynamic> toMap() {
    if (examplePhrases.isNotEmpty) {
      for (var element in examplePhrases) {
        element.toLowerCase();
      }
    }
    if (synonyms.isNotEmpty) {
      for (var element in synonyms) {
        element.toLowerCase();
      }
    }
    if (antonyms.isNotEmpty) {
      for (var element in antonyms) {
        element.toLowerCase();
      }
    }
    return {
      AUTHOR: FirebaseGlobal.auth.currentUser!.displayName,
      TYPE: type,
      WORD: word,
      TIMESTAMP: timestamp,
      DEFINITION: definitions,
      SEMANTIC_FIELD: semanticFields,
      EXAMPLE_PHRASES: examplePhrases,
      SYNONYMS: synonyms,
      ANTONYMS: antonyms,
      GENDER: gender,
      MULTEPLICITY: multeplicity,
      TIPOLOGY: tipology,
      ITALIAN_TYPE: italianType,
      ITALIAN_CORRESPONDENCE: italianCorrespondence,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json, String id) {
    return Word(
      author: json[AUTHOR],
      id: id,
      type: json[TYPE],
      word: json[WORD],
      timestamp: json[TIMESTAMP] as Timestamp,
      definitions: List<String>.from(json[DEFINITION]),
      semanticFields: List<String>.from(json[SEMANTIC_FIELD]),
      examplePhrases: List<String>.from(json[EXAMPLE_PHRASES]),
      synonyms: List<String>.from(json[SYNONYMS]),
      antonyms: List<String>.from(json[ANTONYMS]),
      gender: json[GENDER],
      multeplicity: json[MULTEPLICITY],
      tipology: json[TIPOLOGY],
      italianType: json[ITALIAN_TYPE],
      italianCorrespondence: json[ITALIAN_CORRESPONDENCE],
    );
  }

  @override
  String toString() {
    return "Type: $type \nWord: $word \nDefinition: $definitions \nSemantic Filed: $semanticFields \nPhrases: $examplePhrases \nSyn: $synonyms \nCon: $antonyms \nTipology: $tipology \nGender: $gender \nMult: $multeplicity \n";
  }
}
