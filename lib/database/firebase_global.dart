import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseGlobal {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference wordBooks =
      FirebaseFirestore.instance.collection('books');
  static final CollectionReference dailyWords =
      FirebaseFirestore.instance.collection('word_of_the_day');
  static const String wordBook = 'book';
  static const String words = 'words';
}
