import 'dart:developer';

import 'package:app_word/models/word.dart';

class Book {
  static const ID = "ID";
  static const NAME = "Name";
  static const PIN = "Pin";
  static const MEMBERS = "Members";

  String id = "";
  String name = "";
  String pin = "";
  List<Word> words = [];
  List<String> members = [];

  Book({
    String? id,
    required this.name,
    required this.pin,
    required this.members,
  }) : id = id ?? "";

  Map<String, dynamic> toMap() {
    return {
      // ID: id,
      NAME: name,
      PIN: pin,
      MEMBERS: members,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json, String id) {
    var book = Book(
      id: id,
      name: json[NAME],
      pin: json[PIN],
      members: List<String>.from(json[MEMBERS]),
    );

    book.id = id;

    return book;
  }
}
