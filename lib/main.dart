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


/// ✅ BACKGROUND HANDLER
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("🔔 Background Notification: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// Background notifications
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  /// ✅ MOVE PROVIDER HERE (IMPORTANT FIX)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MeetingProvider()),
        ChangeNotifierProvider(create: (_) => CheckinOutProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


/// ✅ MAIN APP
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

    /// Delay to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFCM();
    });
  }


  /// ✅ FCM INITIALIZATION
  Future<void> _initFCM() async {

    /// Request permission (Android 13+ / iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Get token
    String? token = await _messaging.getToken();
    debugPrint("📱 FCM TOKEN: $token");

    /// Save token
    if (token != null) {
      context.read<NotificationProvider>().saveDeviceToken(token);
    }

    /// 🔔 FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      debugPrint("🔔 Foreground Notification: ${message.notification?.title}");

      context.read<NotificationProvider>()
          .addNotificationFromPush(message);
    });

    /// 📲 CLICK ACTION
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      debugPrint("👉 Notification Clicked");

      context.read<NotificationProvider>()
          .openNotification(message);
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LensFed",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LesnsfedSplash(),
    );
  }
}