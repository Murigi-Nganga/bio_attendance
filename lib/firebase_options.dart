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
    apiKey: 'AIzaSyDe8H4ozE1MBGbij_OTokiaRZQ8btY2y-o',
    appId: '1:623015467302:web:aadaa12dafb2fedb5249e7',
    messagingSenderId: '623015467302',
    projectId: 'bio-attendance-5e701',
    authDomain: 'bio-attendance-5e701.firebaseapp.com',
    storageBucket: 'bio-attendance-5e701.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-31c0F11j53fEZmcLI5cDmvHwdudYNdo',
    appId: '1:623015467302:android:d9157eb6ce5dfec85249e7',
    messagingSenderId: '623015467302',
    projectId: 'bio-attendance-5e701',
    storageBucket: 'bio-attendance-5e701.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFyYUQs9wpjRNFMcWxph57L_fAvmlbLlY',
    appId: '1:623015467302:ios:fedfa91609b8f5d15249e7',
    messagingSenderId: '623015467302',
    projectId: 'bio-attendance-5e701',
    storageBucket: 'bio-attendance-5e701.appspot.com',
    iosBundleId: 'com.example.bioAttendance',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFyYUQs9wpjRNFMcWxph57L_fAvmlbLlY',
    appId: '1:623015467302:ios:6367533d22dd6e195249e7',
    messagingSenderId: '623015467302',
    projectId: 'bio-attendance-5e701',
    storageBucket: 'bio-attendance-5e701.appspot.com',
    iosBundleId: 'com.example.bioAttendance.RunnerTests',
  );
}
