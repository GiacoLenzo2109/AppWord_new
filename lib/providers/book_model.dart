import 'package:app_word/util/constants.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:flutter/widgets.dart';

class BookModel extends ChangeNotifier {
  final Map<String, List<String>> _words = {
    Constants.personalBook: [],
    Constants.classBook: [],
  };
  final Map<String, List<String>> _selectedWords = {};
  var _selectedBook = Constants.personalBook;

  Map<String, List<String>> get words => _words;
  Map<String, List<String>> get selectedWords => _selectedWords;

  String get selectedBook => _selectedBook;

  void setSelectedBook(String book) => _selectedBook = book;

  /// Adds [word] to words. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(String book, String word) {
    if (_words[book] == null) {
      _words[book] = [];
    }
    _words[book]!.add(word);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(String book, String word) {
    if (_words[book] != null) _words[book]!.remove(word);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll(String book) {
    if (_words[book] != null) _words.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Adds [word] to selectedWords to delete.
  void addSelectedWord(String book, String word) {
    if (_selectedWords[book] == null) {
      _selectedWords[book] = [];
    }
    _selectedWords[book]!.add(word);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAllSelectedWords() {
    _selectedWords.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
