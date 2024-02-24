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
    apiKey: 'AIzaSyD-3JHq6HxczgGBoeHyES210zcz4MNAXSg',
    appId: '1:966863187003:web:93cfb3d2eccadef770401e',
    messagingSenderId: '966863187003',
    projectId: 'viexplorer-3c58d',
    authDomain: 'viexplorer-3c58d.firebaseapp.com',
    storageBucket: 'viexplorer-3c58d.appspot.com',
    measurementId: 'G-EWM3M13QC5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0U1px6Lt1zMsieq7eZmdwArEyLhoLEns',
    appId: '1:966863187003:android:57340500e0abbc1570401e',
    messagingSenderId: '966863187003',
    projectId: 'viexplorer-3c58d',
    storageBucket: 'viexplorer-3c58d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9JFpZCyRVZecLs_zk8clDJ_O6Gn6biwM',
    appId: '1:966863187003:ios:58d2e5fa8d75b78670401e',
    messagingSenderId: '966863187003',
    projectId: 'viexplorer-3c58d',
    storageBucket: 'viexplorer-3c58d.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9JFpZCyRVZecLs_zk8clDJ_O6Gn6biwM',
    appId: '1:966863187003:ios:01b59c72229b691670401e',
    messagingSenderId: '966863187003',
    projectId: 'viexplorer-3c58d',
    storageBucket: 'viexplorer-3c58d.appspot.com',
    iosBundleId: 'com.example.app.RunnerTests',
  );
}