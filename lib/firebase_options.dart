// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDzFJzlnbxWc9DsQN76g4Q9I-xVRsqnSvQ',
    appId: '1:797401564054:web:b07ae075bfa76232bb53b7',
    messagingSenderId: '797401564054',
    projectId: 'paistats-read-only',
    authDomain: 'paistats-read-only.firebaseapp.com',
    storageBucket: 'paistats-read-only.appspot.com',
    measurementId: 'G-D4YNZ7SXM3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWfZyGj77WM7vvK36wilTq0qHx4PA-QRU',
    appId: '1:797401564054:android:db07101bb10da751bb53b7',
    messagingSenderId: '797401564054',
    projectId: 'paistats-read-only',
    storageBucket: 'paistats-read-only.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCl8Rdmd_iaM_DCP2qL4iHdrillrZqlGqg',
    appId: '1:797401564054:ios:ac7a9ef7380a8d84bb53b7',
    messagingSenderId: '797401564054',
    projectId: 'paistats-read-only',
    storageBucket: 'paistats-read-only.appspot.com',
    iosClientId: '797401564054-vve3c9a1feuer5m2j2rqcjejd9cfoqfj.apps.googleusercontent.com',
    iosBundleId: 'com.advithast.paistats',
  );
}
