
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "YOUR_ANDROID_API_KEY",
    appId: "YOUR_ANDROID_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "lensfed-ed934",
    storageBucket: "lensfed-ed934.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "YOUR_IOS_API_KEY",
    appId: "YOUR_IOS_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "lensfed-ed934",
    storageBucket: "lensfed-ed934.appspot.com",
    iosBundleId: "com.example.lensfed",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "YOUR_WEB_API_KEY",
    appId: "YOUR_WEB_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "lensfed-ed934",
    authDomain: "lensfed-ed934.firebaseapp.com",
    storageBucket: "lensfed-ed934.appspot.com",
  );

  static const FirebaseOptions macos = ios;
  static const FirebaseOptions windows = android;
  static const FirebaseOptions linux = android;
}