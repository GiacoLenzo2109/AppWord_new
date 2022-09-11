import 'dart:collection';
import 'dart:developer';

import 'package:app_word/models/word.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:flutter/widgets.dart';

class BookModel extends ChangeNotifier {
  bool _isStickyAlphabeth = true;

  bool get isStickyAlphabeth => _isStickyAlphabeth;

  set isStickyAlphabeth(bool isSticky) {
    _isStickyAlphabeth = isSticky;
    notifyListeners();
  }

  String _name = "";
  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String _id = "";
  String get id => _id;

  void setId(String id) {
    _id = id;
    notifyListeners();
  }

  final Map<String, Word> _words = {};
  final Map<String, List<String>> _selectedWords = {};
  var _selectedBook = Constants.personalBook;

  //Map<String, Word> get words => _words;
  List<Word> get words {
    var words = _words.values.toList();

    words.sort((a, b) => a.word.compareTo(b.word));
    return words;
  }

  List<String> get usersRanking {
    var words = _words.values.toList();

    SplayTreeMap<String, int> mapUsers = SplayTreeMap();

    for (var word in words) {
      mapUsers.putIfAbsent(word.author, () => 0);

      mapUsers.update(word.author, (value) => value++);
    }

    List<String> usersRanking = [];

    for (var user in mapUsers.keys) {
      usersRanking.add(user);

      if (usersRanking.length == 3) {
        break;
      }
    }

    return usersRanking;
  }

  Map<String, List<String>> get selectedWords => _selectedWords;

  String get selectedBook => _selectedBook;

  void setSelectedBook(String book) => _selectedBook = book;

  void setWords(List<Word> words) {
    _words.clear();
    for (var word in words) {
      addWord(word);
    }
    notifyListeners();
  }

  /// Adds [word] to words. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void addWord(Word word) {
    _words.putIfAbsent(word.id, () => word);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updateWord(Word word) {
    _words.update(word.id, (w) => word);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeWord(String wordId) {
    _words.remove(wordId);
    notifyListeners();
  }

  bool isWordCreated(String word) {
    return _words.values.where((w) => w.word == word).isNotEmpty;
  }

  /// Removes all items from the cart.
  void removeAllWords() {
    _words.clear();
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

  List<Word> get wordsByTimestamp {
    var words = _words.values.toList();

    words.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return words;
  }
}
