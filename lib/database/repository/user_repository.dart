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
    await FirebaseGlobal.users.doc(user.uid).set(
          UserDb(user.email!, user.displayName!).toMap(),
        );
    return;
  }

  static Future<DocumentSnapshot<Object?>> getUser({
    required BuildContext context,
    required String uid,
  }) async {
    return FirebaseGlobal.users.doc(uid).get();
  }

  static Future<void> updateUser({
    required BuildContext context,
    required User user,
  }) async {
    FirebaseGlobal.users
        .doc(FirebaseGlobal.auth.currentUser!.uid)
        .update(UserDb(user.email!, user.displayName!).toMap());
  }
}
