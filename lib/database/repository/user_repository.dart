import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository {
  static Future<void> createUser({
    required BuildContext context,
    required User user,
  }) async {
    var _user = await getUser(context: context, uid: user.uid);
    var userDb = UserDb(email: user.email!, username: user.displayName!);
    if (_user != null) {
      userDb.isAdmin = _user.isAdmin;
    }
    await FirebaseGlobal.users.doc(user.uid).set(
          userDb.toMap(),
        );
    return;
  }

  static Future<UserDb?> getUser({
    required BuildContext context,
    required String uid,
  }) async {
    var user = await FirebaseGlobal.users.doc(uid).get();
    if (!user.exists) return null;
    return UserDb.fromJson(user.data() as Map<String, dynamic>);
  }

  static Future<void> updateUser({
    required BuildContext context,
    required User user,
  }) async {
    FirebaseGlobal.users.doc(FirebaseGlobal.auth.currentUser!.uid).update(
        UserDb(email: user.email!, username: user.displayName!).toMap());
  }
}
