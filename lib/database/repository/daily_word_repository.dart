import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/daily_word.dart';
import 'package:app_word/models/word.dart';
import 'package:flutter/material.dart';

class DailyWordRepository {
  static Future<DailyWord> addDailyWord({
    required BuildContext context,
    required Word word,
    required List<String> members,
  }) async {
    var dailyWord = DailyWord(word: word, members: members);

    var id = FirebaseGlobal.dailyWords.doc().id;

    await FirebaseGlobal.dailyWords.doc(id).set(dailyWord.toMap());

    dailyWord.id = id;
    return dailyWord;
  }

  static Future<DailyWord> updateDailyWord({
    required BuildContext context,
    required DailyWord dailyWord,
  }) async {
    await FirebaseGlobal.dailyWords.doc(dailyWord.id).set(dailyWord.toMap());

    return dailyWord;
  }

  static Future<DailyWord?> getDailyWord({
    required BuildContext context,
  }) async {
    var snapshot = await FirebaseGlobal.dailyWords
        .where(DailyWord.MEMBERS,
            arrayContains: FirebaseGlobal.auth.currentUser!.uid)
        .orderBy(Word.TIMESTAMP, descending: true)
        .limit(1)
        .get();
    var words = snapshot.docs
        .map((e) => DailyWord.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
    return words.isEmpty ? null : words.first;
  }

  static Future<DailyWord> getWord(
      {required BuildContext context, required String wordId}) async {
    var snapshot = await FirebaseGlobal.dailyWords.doc(wordId).get();
    return DailyWord.fromJson(snapshot.data() as Map<String, dynamic>, wordId);
  }
}
