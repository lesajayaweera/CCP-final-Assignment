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
        return windows;
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
    apiKey: 'AIzaSyB8S9T7hFds37nEBOn80XaYy31nkgzVV8M',
    appId: '1:77184994425:web:1bfdd452290934f90818a8',
    messagingSenderId: '77184994425',
    projectId: 'sportignite3',
    authDomain: 'sportignite3.firebaseapp.com',
    storageBucket: 'sportignite3.firebasestorage.app',
    measurementId: 'G-TWV32KPQZG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDowuNSPQ1PdwvbnQ--_MCmw8z5i3gOD60',
    appId: '1:77184994425:android:0e7f250be47cb3920818a8',
    messagingSenderId: '77184994425',
    projectId: 'sportignite3',
    storageBucket: 'sportignite3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCi7432LL9dNy9LwolN2h6DrflXqJPJk6Q',
    appId: '1:77184994425:ios:fc906957dee89a3b0818a8',
    messagingSenderId: '77184994425',
    projectId: 'sportignite3',
    storageBucket: 'sportignite3.firebasestorage.app',
    iosBundleId: 'com.example.sportIgnite',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBY4Bie2IBFH99xiY-9OWc8B-Ml8bhRKOo',
    appId: '1:58454763639:ios:e54a84fe5b5f649dc97e72',
    messagingSenderId: '58454763639',
    projectId: 'sportignite-88208',
    storageBucket: 'sportignite-88208.firebasestorage.app',
    iosBundleId: 'com.example.sportIgnite',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBoPKNzkr4IkixAt4a2bqYl_WeRj1M1mT0',
    appId: '1:214600243516:web:632d14e2a9b4058b896639',
    messagingSenderId: '214600243516',
    projectId: 'sportignite2',
    authDomain: 'sportignite2.firebaseapp.com',
    storageBucket: 'sportignite2.firebasestorage.app',
    measurementId: 'G-40514QQ5RL',
  );

}