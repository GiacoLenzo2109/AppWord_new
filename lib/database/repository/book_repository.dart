import 'dart:developer';
import 'dart:io';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/models/word.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:flutter/widgets.dart';

class BookRepository {
  /// BOOK
  ///
  /// INSERT
  static Future<Book> addBook(
      {required BuildContext context, required Book book}) async {
    LoadingWidget.showOnMain();
    book.members.add(FirebaseGlobal.auth.currentUser!.uid);
    var bookId = FirebaseGlobal.wordBooks.doc().id;

    await FirebaseGlobal.wordBooks.doc(bookId).set(book.toMap()).whenComplete(
          () => Navigator.pop(context),
        );
    book.id = bookId;
    Navigator.pop(NavigationService.navigatorKey.currentContext!);

    return book;
  }

  /// GET
  static Future<List<Book>> getAllBooks({required BuildContext context}) async {
    var snapshot = await FirebaseGlobal.wordBooks
        .where(Book.MEMBERS,
            arrayContains: FirebaseGlobal.auth.currentUser!.uid)
        .get();

    List<Book> books = snapshot.docs
        .map((e) => Book.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();

    for (var book in books) {
      var words = await getWords(context: context, bookId: book.id);
      book.words = words;
    }
    return books;
  }

  /// GET
  static Future<Book?> getBook({
    required BuildContext context,
    required String pin,
  }) async {
    var snapshot = await FirebaseGlobal.wordBooks
        .where(Book.PIN, isEqualTo: pin)
        .limit(1)
        .get();
    List<Book> books = snapshot.docs
        .map((e) => Book.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();

    return books.isEmpty ? null : books.first;
  }

  /// GET
  static Future<Book?> getBookById({
    required BuildContext context,
    required String id,
  }) async {
    var snapshot = await FirebaseGlobal.wordBooks.doc(id).get();
    Book book = Book.fromJson(snapshot.data() as Map<String, dynamic>, id);

    return book;
  }

  /// JOIN
  static Future<Book?> joinBook({
    required BuildContext context,
    required String pin,
  }) async {
    var snapshot = await FirebaseGlobal.wordBooks
        .where(Book.PIN, isEqualTo: pin)
        .limit(1)
        .get();
    List<Book> books = snapshot.docs
        .map((e) => Book.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();

    if (books.isEmpty) {
      DialogUtil.openDialog(
          context: context,
          builder: (context) =>
              const ErrorDialogWidget("Rubrica non esistente!"));
      return null;
    }

    var book = books.first;
    if (book.members.contains(FirebaseGlobal.auth.currentUser!.uid)) {
      DialogUtil.openDialog(
          context: context,
          builder: (context) =>
              const ErrorDialogWidget("Sei già dentro questa rubrica!"));
      return null;
    }
    book.members.add(FirebaseGlobal.auth.currentUser!.uid);
    await FirebaseGlobal.wordBooks.doc(book.id).set(book.toMap());
    return book;
  }

  /// LEAVE
  static Future<void> leaveBook({
    required BuildContext context,
    required Book book,
  }) async {
    LoadingWidget.showOnMain();
    book.members.remove(FirebaseGlobal.auth.currentUser!.uid);
    await FirebaseGlobal.wordBooks.doc(book.id).set(book.toMap());
    Navigator.pop(NavigationService.navigatorKey.currentContext!);
    return;
  }

  /// WORDS
  ///
  /// GET
  static Future<List<Word>> getWords({
    required BuildContext context,
    required String bookId,
  }) async {
    var snapshot = await FirebaseGlobal.wordBooks
        .doc(bookId)
        .collection(FirebaseGlobal.words)
        .orderBy(Word.WORD, descending: false)
        .get();

    return snapshot.docs.map((e) => Word.fromJson(e.data(), e.id)).toList();
  }

  static Future<Word> getWord({
    required BuildContext context,
    required String bookId,
    required String wordId,
  }) async {
    var snapshot = await FirebaseGlobal.wordBooks
        .doc(bookId)
        .collection(FirebaseGlobal.words)
        .doc(wordId)
        .get();

    return Word.fromJson(snapshot.data() as Map<String, dynamic>, wordId);
  }

  /// INSERT
  static Future<Word> addWordToBook({
    required BuildContext context,
    required String bookId,
    required Word word,
  }) async {
    //LoadingWidget.showOnMain();

    if (word.id.isNotEmpty) {
      var snapshot = await FirebaseGlobal.wordBooks
          .doc(bookId)
          .collection(FirebaseGlobal.words)
          .doc(word.id)
          .get();
      if (snapshot.exists) {
        DialogUtil.openDialog(
          context: context,
          builder: (context) =>
              const ErrorDialogWidget("Vocabolo già inserito"),
        );
        return Word();
      }
    }

    var wordId = FirebaseGlobal.wordBooks
        .doc(bookId)
        .collection(FirebaseGlobal.words)
        .doc()
        .id;

    await FirebaseGlobal.wordBooks
        .doc(bookId)
        .collection(FirebaseGlobal.words)
        .doc(word.id.isNotEmpty ? word.id : wordId)
        .set(word.toMap());
    word.id = wordId;

    return word;
  }

  /// UPDATE
  static Future<void> updateWord({
    required BuildContext context,
    required String bookId,
    required Word word,
  }) async {
    LoadingWidget.showOnMain();
    await FirebaseGlobal.wordBooks
        .doc(bookId)
        .collection(FirebaseGlobal.words)
        .doc(word.id)
        .set(word.toMap());
    Navigator.pop(NavigationService.navigatorKey.currentContext!);
    return;
  }

  /// REMOVE
  static Future<void> removeWord({
    required BuildContext context,
    required String bookId,
    required String wordId,
  }) async {
    LoadingWidget.showOnMain();
    await FirebaseGlobal.wordBooks
        .doc(bookId)
        .collection(FirebaseGlobal.words)
        .doc(wordId)
        .delete();
    Navigator.pop(NavigationService.navigatorKey.currentContext!);
    return;
  }
}
