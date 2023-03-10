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
    apiKey: 'AIzaSyBhhhek1kd8mI3y1G95U1LbXll0q2uxC2s',
    appId: '1:726651514173:web:b1611c478a69c8c850e954',
    messagingSenderId: '726651514173',
    projectId: 'clone-2c877',
    authDomain: 'clone-2c877.firebaseapp.com',
    storageBucket: 'clone-2c877.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuQoORBxJYHChgLHkEOlSlP-A4mpsDHlY',
    appId: '1:726651514173:android:7466030b7eff281750e954',
    messagingSenderId: '726651514173',
    projectId: 'clone-2c877',
    storageBucket: 'clone-2c877.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7IHglBI5GypPOJn9kgxeMEgGyF0cR8rc',
    appId: '1:726651514173:ios:b21749ab1e67e0c850e954',
    messagingSenderId: '726651514173',
    projectId: 'clone-2c877',
    storageBucket: 'clone-2c877.appspot.com',
    iosClientId: '726651514173-nr0r6tvbipbv64m3lhb8h73ho6lv5n1b.apps.googleusercontent.com',
    iosBundleId: 'com.example.usersApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7IHglBI5GypPOJn9kgxeMEgGyF0cR8rc',
    appId: '1:726651514173:ios:b21749ab1e67e0c850e954',
    messagingSenderId: '726651514173',
    projectId: 'clone-2c877',
    storageBucket: 'clone-2c877.appspot.com',
    iosClientId: '726651514173-nr0r6tvbipbv64m3lhb8h73ho6lv5n1b.apps.googleusercontent.com',
    iosBundleId: 'com.example.usersApp',
  );
}
