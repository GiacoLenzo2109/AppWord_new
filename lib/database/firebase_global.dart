import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseGlobal {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
  static final CollectionReference wordBooks =
      FirebaseFirestore.instance.collection('Books');
  static final CollectionReference dailyWords =
      FirebaseFirestore.instance.collection('DailyWords');
  static const String wordBook = 'Book';
  static const String words = 'Words';
}
