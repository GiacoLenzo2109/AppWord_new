import 'package:app_word/widgets/book_view/word_item.dart';
import 'package:flutter/widgets.dart';

class BookModel extends ChangeNotifier {
  final List<String> _words = [];
  final List<String> _selectedWords = [];

  List<String> get words => _words;
  List<String> get selectedWords => _selectedWords;

  /// Adds [word] to words. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(String word) {
    _words.add(word);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _words.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Adds [word] to selectedWords to delete.
  void addSelectedWord(String word) {
    _selectedWords.add(word);
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
