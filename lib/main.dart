import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/checkinOut_provider.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Provider/member_provider.dart';
import 'package:lensfed/Provider/notication_provider.dart';

import 'package:lensfed/Views/Splash.dart';


/// BACKGROUND NOTIFICATION HANDLER
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Notification: ${message.notification?.title}");
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }


  /// INITIALIZE FCM
  Future<void> _initFCM() async {

    /// Request permission (Android 13+)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Get device token
    String? token = await _messaging.getToken();

    print("FCM TOKEN: $token");

    /// Send token to provider
    if (token != null) {
      context.read<NotificationProvider>().saveDeviceToken(token);
    }

    /// FOREGROUND NOTIFICATION
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("Foreground Notification: ${message.notification?.title}");

      context.read<NotificationProvider>().addNotificationFromPush(message);

    });

    /// CLICK NOTIFICATION
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("Notification Clicked");

      context.read<NotificationProvider>().openNotification(message);

    });
  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MeetingProvider()),
        ChangeNotifierProvider(create: (_) => CheckinOutProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),

      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LesnsfedSplash(),
      ),
    );
  }
}