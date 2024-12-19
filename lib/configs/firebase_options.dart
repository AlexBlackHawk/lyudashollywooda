// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYD1uJJCAzn6gRGhGXejRbtIfAIl0BdCY',
    appId: '1:448346880353:android:7cac8ff5633ecbc9346d20',
    messagingSenderId: '448346880353',
    projectId: 'lyudashollywooda-48c11',
    storageBucket: 'lyudashollywooda-48c11.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9NgTdXw0v1-MbQi3Bu1PW-_OVqAaYbpo',
    appId: '1:448346880353:ios:8a07394740e542b2346d20',
    messagingSenderId: '448346880353',
    projectId: 'lyudashollywooda-48c11',
    storageBucket: 'lyudashollywooda-48c11.appspot.com',
    androidClientId: '448346880353-b471dpjjp5np5c0g2h5lr2vqqf4ds1a6.apps.googleusercontent.com',
    iosClientId: '448346880353-f556oi9qgv5k7e9knem479f0o92ucjjn.apps.googleusercontent.com',
    iosBundleId: 'com.eon.lyudashollywooda',
  );
}
