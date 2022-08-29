// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRnW8Mr9tnw3hJIW72XLwRstjt7Jc-s6Q',
    appId: '1:684137879377:web:8d3effcbac752a4b6e2570',
    messagingSenderId: '684137879377',
    projectId: 'starvation-appword',
    authDomain: 'starvation-appword.firebaseapp.com',
    storageBucket: 'starvation-appword.appspot.com',
    measurementId: 'G-B4XB5LCNES',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBy4ddlty8VyRRT48Dgj4WLmBrjtqKLXv8',
    appId: '1:684137879377:android:1dd2f54b1e4a8e796e2570',
    messagingSenderId: '684137879377',
    projectId: 'starvation-appword',
    storageBucket: 'starvation-appword.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCliNa_AHapcbKbBzZsydtiOjt6-bYMLJo',
    appId: '1:684137879377:ios:8774586f846ff7eb6e2570',
    messagingSenderId: '684137879377',
    projectId: 'starvation-appword',
    storageBucket: 'starvation-appword.appspot.com',
    androidClientId: '684137879377-2b7pfj4k3vg2grpcmn6g6v1ojdnc3h0a.apps.googleusercontent.com',
    iosClientId: '684137879377-s1al0p1ko3eg7m7k5sjdb0nt21q31fo2.apps.googleusercontent.com',
    iosBundleId: 'com.starvation.appword.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCliNa_AHapcbKbBzZsydtiOjt6-bYMLJo',
    appId: '1:684137879377:ios:74b8fde6bb67d2c16e2570',
    messagingSenderId: '684137879377',
    projectId: 'starvation-appword',
    storageBucket: 'starvation-appword.appspot.com',
    androidClientId: '684137879377-2b7pfj4k3vg2grpcmn6g6v1ojdnc3h0a.apps.googleusercontent.com',
    iosClientId: '684137879377-aaqo898dqrrnumsv499tdsn535qfk1vi.apps.googleusercontent.com',
    iosBundleId: 'com.example.appword',
  );
}