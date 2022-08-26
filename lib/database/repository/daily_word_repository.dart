import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/word.dart';
import 'package:flutter/material.dart';

class DailyWordRepository {
  static Future<Word> addDailyWord({
    required BuildContext context,
    required Word dailyWord,
  }) async {
    await FirebaseGlobal.dailyWords.add(dailyWord.toMap());
    return dailyWord;
  }

  static Future<Word> updateDailyWord({
    required BuildContext context,
    required Word dailyWord,
  }) async {
    await FirebaseGlobal.dailyWords.doc(dailyWord.id).set(dailyWord.toMap());
    return dailyWord;
  }

  static Future<Word?> getDailyWord({
    required BuildContext context,
  }) async {
    var snapshot = await FirebaseGlobal.dailyWords
        .orderBy(Word.TIMESTAMP, descending: true)
        .limit(1)
        .get();
    var words = snapshot.docs
        .map((e) => Word.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
    return words.isEmpty ? null : words.first;
  }

  static Future<Word> getWord(
      {required BuildContext context, required String wordId}) async {
    var snapshot = await FirebaseGlobal.dailyWords.doc(wordId).get();
    return Word.fromJson(snapshot.data() as Map<String, dynamic>, wordId);
  }
}
