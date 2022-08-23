import 'package:app_word/database/firebase_global.dart';

class UserDb {
  String email;
  String username;

  UserDb(this.email, this.username);

  Map<String, dynamic> toMap() {
    return {
      'uid': FirebaseGlobal.auth.currentUser!.uid,
      'email': email,
      'username': username,
    };
  }
}
