import 'dart:developer';

import 'package:app_word/database/firebase_global.dart';
import 'package:app_word/database/repository/user_repository.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/widgets/dialogs/error_dialog_widget.dart';
import 'package:app_word/widgets/global/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/dialog_util.dart';

class AuthenticationRepository {
  static const GOOGLE_USER = "GOOGLE";
  static const NORMAL_USER = "NORMAL";
  static const USER_TYPE = "USER_TYPE";

  /// Check if is google user
  static bool isGoogleLogged() {
    for (var value in FirebaseGlobal.auth.currentUser!.providerData) {
      if (value.providerId == 'google.com') return true;
    }
    return false;
  }

  /// Check if is email verified
  static Future<void> checkEmailVerified(
      {required BuildContext context}) async {
    User? user = FirebaseGlobal.auth.currentUser;
    if (user != null) {
      log("Reload utente");
      await user.reload();
      if (user.emailVerified) {
        NavigatorUtil.navigateAndReplace(
          context: context,
          route: NavigatorUtil.MAIN,
        );
      }
    }
    return;
  }

  /// Register user auth
  static Future<void> createUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      DialogUtil.openDialog(
        context: context,
        builder: (context) => const LoadingWidget(),
      );
      await FirebaseGlobal.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (FirebaseGlobal.auth.currentUser != null) {
        await FirebaseGlobal.auth.currentUser!.updateDisplayName(username);
        await UserRepository.createUser(
            context: context, user: FirebaseGlobal.auth.currentUser!);
        await FirebaseGlobal.auth.currentUser!.sendEmailVerification();
        NavigatorUtil.navigatePopAndGo(
          context: context,
          route: NavigatorUtil.EMAIL_VERIFICATION,
        );
      }
    } on FirebaseAuthException catch (e) {
      var error = "";
      if (e.code == 'weak-password') {
        error = "Password debole!";
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        error = "Email già in uso!";
        log('The account already exists for that email.');
      }
      Navigator.pop(context);
      DialogUtil.openDialog(
        context: context,
        builder: (context) => ErrorDialogWidget(error),
      );
    } catch (e) {
      log("Eccezione: $e");
    }
  }

  /// Log in with email and password
  static Future<void> signInWithEmailAndPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    var error = "";
    try {
      await FirebaseGlobal.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (FirebaseGlobal.auth.currentUser != null) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString(USER_TYPE, NORMAL_USER);
        if (!FirebaseGlobal.auth.currentUser!.emailVerified) {
          NavigatorUtil.navigatePopAndGo(
            context: context,
            route: NavigatorUtil.EMAIL_VERIFICATION,
          );
        } else {
          NavigatorUtil.navigateAndReplace(
            context: context,
            route: NavigatorUtil.MAIN,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'user-not-found') {
        error = 'Email o password sbagliata!';
      } else if (e.code == 'wrong-password') {
        error = 'Password sbagliata, riprova!';
      }
      DialogUtil.openDialog(
        context: context,
        builder: (context) => ErrorDialogWidget(
          error.isEmpty ? e.toString() : error,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
    return;
  }

  /// Log in with google account
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      FirebaseAuth auth = FirebaseGlobal.auth;
      //User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn().then(
        (value) {
          if (value != null) LoadingWidget.show(context);
          return value;
        },
      );

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          //final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(USER_TYPE, GOOGLE_USER);

          await FirebaseGlobal.auth.currentUser!.updateDisplayName(
            googleSignInAccount.displayName,
          );

          var user = await UserRepository.getUser(
            context: context,
            uid: googleSignInAccount.id,
          );

          if (user == null) {
            await UserRepository.createUser(
                context: context, user: FirebaseGlobal.auth.currentUser!);
          }
          NavigatorUtil.navigateAndReplace(
            context: context,
            route: NavigatorUtil.MAIN,
          );

          //user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
          } else if (e.code == 'invalid-credential') {
            // handle the error here
          }
        } catch (e) {
          // handle the error here
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        // handle the error here
      }
    } catch (e) {
      // handle the error here
    }
    return;
  }

  static Future<void> signOut({required BuildContext context}) async {
    LoadingWidget.show(context);

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();

      await FirebaseAuth.instance.signOut().whenComplete(
            () => Navigator.of(context).pop(),
          );
    } catch (e) {
      log(e.toString());
    }
    return;
  }
}
