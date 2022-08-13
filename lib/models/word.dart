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

  static const ID = "ID";
  String id;

  static const TYPE = "TYPE";
  String type;

  static const WORD = "WORD";
  String word;

  static const TIMESTAMP = "TIMESTAMP";
  Timestamp timestamp;

  static const DEFINITION = "DEFINITIONS";
  List<String> definitions;

  static const SEMANTIC_FIELD = "SEMANTIC_FIELD";
  List<String> semanticFields;

  static const EXAMPLE_PHRASES = "EXAMPLE_PHRASES";
  List<String> examplePhrases;

  static const SYNONYMS = "SYNONYMS";
  List<String> synonyms;

  static const ANTONYMS = "ANTONYMS";
  List<String> antonyms;

  static const GENDER = "GENDER";
  String gender;

  static const MULTEPLICITY = "MULTEPLICITY";
  String multeplicity;

  static const TIPOLOGY = "TIPOLOGY";
  String tipology;

  static const ITALIAN_TYPE = "ITALIAN_TYPE";
  String italianType;

  static const ITALIAN_CORRESPONDENCE = "ITALIAN_CORRESPONDENCE";
  String italianCorrespondence;

  Word(
      {String? id,
      String? type,
      String? word,
      List<String>? definitions,
      List<String>? semanticFields,
      List<String>? examplePhrases,
      String? timestamp,
      String? italianType,
      String? italianCorrespondence,
      List<String>? synonyms,
      List<String>? antonyms,
      String? tipology,
      String? gender,
      String? multeplicity})
      : id = id ?? "",
        type = type ?? "Verbo",
        word = word ?? "",
        timestamp = Timestamp.now(),
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
      'AUTHOR': FirebaseGlobal.auth.currentUser!.uid,
      ID: id,
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

  @override
  String toString() {
    return "Type: $type \nWord: $word \nDefinition: $definitions \nSemantic Filed: $semanticFields \nPhrases: $examplePhrases \nSyn: $synonyms \nCon: $antonyms \nTipology: $tipology \nGender: $gender \nMult: $multeplicity \n";
  }
}
