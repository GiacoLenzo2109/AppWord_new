import 'dart:developer';

import 'package:app_word/models/book.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:flutter/material.dart';

class BookListProvider extends ChangeNotifier {
  final Map<String, Book> _books = {};

  List<Book> get books {
    var books = _books.values.toList();
    books.sort((a, b) => a.name.compareTo(b.name));
    return books;
  }

  List<Book> get booksRanking {
    var books = _books.values.toList();
    books.sort((a, b) => a.words.length.compareTo(b.words.length));
    return books;
  }

  final Map<String, BookModel> _bookProviders = {};
  List<BookModel> get bookProviders => _bookProviders.values.toList();

  void addBook(Book book) {
    _books.putIfAbsent(book.id, () => book);
    addBookProvider(book);
    notifyListeners();
  }

  void removeBook(String id) {
    _books.remove(id);
    removeBookProvider(id);
    notifyListeners();
  }

  void removeAllBooks() {
    _books.clear();
    removeAllBookProviders();
    notifyListeners();
  }

  void setBooks(List<Book> books) {
    removeAllBooks();
    for (var book in books) {
      addBook(book);
    }
    notifyListeners();
  }

  void addBookProvider(Book book) {
    var provider = BookModel();
    provider.setId(book.id);
    provider.setName(book.name);
    provider.setWords(book.words);
    _bookProviders.putIfAbsent(book.id, () => provider);
    notifyListeners();
  }

  BookModel getBookProvider(String bookId) => _bookProviders[bookId]!;

  void removeBookProvider(String id) {
    _bookProviders.remove(id);
    notifyListeners();
  }

  void removeAllBookProviders() {
    _bookProviders.clear();
    notifyListeners();
  }

  bool booksAreEmpty() {
    for (Book book in books) {
      if (book.words.isNotEmpty) return false;
    }
    return true;
  }
}
