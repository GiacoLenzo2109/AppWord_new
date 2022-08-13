import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WordModel {
  static const modern = "Ita moderno";
  static const letteratura = "Ita letteratura";

  static const verbo = "Verbo";
  static const sostantivo = "Sostantivo";
  static const altro = "Altro";

  static const singular = "Singolare";
  static const plural = "Plurale";
  static const male = "Maschile";
  static const female = "Femminile";

  static const ID = "ID";
  String? _id;

  static const TYPE = "TYPE";
  String? _type;

  static const WORD = "WORD";
  String? _word;

  static const TIMESTAMP = "TIMESTAMP";
  Timestamp? _timestamp;

  static const DEFINITION = "DEFINITIONS";
  List<String>? _definitions;

  static const SEMANTIC_FIELD = "SEMANTIC_FIELDS";
  List<String>? semanticFields;

  static const EXAMPLE_PHRASES = "EXAMPLE_PHRASES";
  List<String>? _examplePhrases;

  static const SYNONYMS = "SYNONYMS";
  List<String>? _synonyms;

  static const ANTONYMS = "ANTONYMS";
  List<String>? _antonyms;

  static const GENDER = "GENDER";
  String? _gender;

  static const MULTEPLICITY = "MULTEPLICITY";
  String? _multeplicity;

  static const TIPOLOGY = "TIPOLOGY";
  String? _tipology;

  static const ITALIAN_TYPE = "ITALIAN_TYPE";
  String? _italianType;

  static const ITALIAN_CORRESPONDENCE = "ITALIAN_CORRESPONDENCE";
  String? _italianCorrespondence;

  String? get id => _id;
  String? get type => _type;
  String? get word => _word;
  Timestamp? get timestamp => _timestamp;

  String? get multeplicity => _multeplicity;
  String? get tipology => _tipology;
  String? get italianType => _italianType;
  String? get italianCorrespondence => _italianCorrespondence;
}
