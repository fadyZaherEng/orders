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
    apiKey: 'AIzaSyBnmPTfQRjrzz0X-Sqx_PGiSz-H3EkecnE',
    appId: '1:749092867694:web:b82915cbdbf7db6ac4a07f',
    messagingSenderId: '749092867694',
    projectId: 'orders-3e5e9',
    authDomain: 'orders-3e5e9.firebaseapp.com',
    storageBucket: 'orders-3e5e9.appspot.com',
    measurementId: 'G-F8SQ8Y9R7B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJ_A8shQOzHPXQWTc8c8ckzALKoj-2D9o',
    appId: '1:749092867694:android:84bbec84796fb7e8c4a07f',
    messagingSenderId: '749092867694',
    projectId: 'orders-3e5e9',
    storageBucket: 'orders-3e5e9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuKYH7_4q6uMp65J89GoyFh8iJGjPMyms',
    appId: '1:749092867694:ios:a3d4d1dc36625b30c4a07f',
    messagingSenderId: '749092867694',
    projectId: 'orders-3e5e9',
    storageBucket: 'orders-3e5e9.appspot.com',
    iosClientId: '749092867694-2giuqb1feb7cn0prf5iscpg09imtb2ei.apps.googleusercontent.com',
    iosBundleId: 'com.example.orders',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuKYH7_4q6uMp65J89GoyFh8iJGjPMyms',
    appId: '1:749092867694:ios:faade96ad28cccd6c4a07f',
    messagingSenderId: '749092867694',
    projectId: 'orders-3e5e9',
    storageBucket: 'orders-3e5e9.appspot.com',
    iosClientId: '749092867694-40qcosf3fmqli46fqvlsqosb4lvhhb8u.apps.googleusercontent.com',
    iosBundleId: 'com.example.orders.RunnerTests',
  );
}
