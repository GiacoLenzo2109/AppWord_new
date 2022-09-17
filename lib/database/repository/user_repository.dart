import 'dart:io';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/models/user.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository {
  static Future<void> createUser({
    required BuildContext context,
    required User user,
  }) async {
    var _user = await getUser(context: context, uid: user.uid);
    var userDb = UserDb(
      email: user.email!,
      username: user.displayName!,
      isAdmin: false,
    );
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

  static Future<bool> isEmailFree({
    required BuildContext context,
    required String email,
  }) async {
    var user = await FirebaseGlobal.users
        .where(UserDb.EMAIL, isEqualTo: email.toLowerCase())
        .get();
    if (user.docs.isEmpty) return true;
    return false;
  }

  static Future<void> updateUser({
    required BuildContext context,
    required User user,
  }) async {
    var _user = await getUser(context: context, uid: user.uid);
    FirebaseGlobal.users
        .doc(FirebaseGlobal.auth.currentUser!.uid)
        .update(UserDb(
          email: user.email!,
          username: user.displayName!,
          isAdmin: _user!.isAdmin,
        ).toMap());
  }
}
