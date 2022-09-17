import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/word.dart';

class UserDb {
  static const EMAIL = "Email";
  static const USERNAME = "Username";
  static const ADMIN = "Admin";

  String email;
  String username;
  bool isAdmin = false;

  UserDb({
    required this.email,
    required this.username,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      ADMIN: isAdmin,
      EMAIL: email,
      USERNAME: username,
    };
  }

  factory UserDb.fromJson(Map<String, dynamic> json) {
    var user = UserDb(
      email: json[EMAIL],
      username: json[USERNAME],
      isAdmin: json[ADMIN],
    );

    return user;
  }
}
