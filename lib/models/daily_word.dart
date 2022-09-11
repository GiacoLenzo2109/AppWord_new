import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/word.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyWord {
  static const ID = "ID";
  static const WORD = "Word";
  static const MEMBERS = "Members";

  String id = "";
  Word word;
  List<String> members;

  DailyWord({required this.word, required this.members});

  Map<String, dynamic> toMap() {
    var map = word.toMap();
    map.putIfAbsent(MEMBERS, () => members);
    return map;
  }

  factory DailyWord.fromJson(Map<String, dynamic> json, String id) {
    var dailyWord = DailyWord(
      word: Word.fromJson(json, id),
      members: List<String>.from(json[MEMBERS]),
    );

    dailyWord.id = id;

    return dailyWord;
  }
}
