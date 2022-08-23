import 'package:app_word/database/firebase_global.dart';

class UserDb {
  String email;
  String username;

  UserDb(this.email, this.username);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
    };
  }
}
