import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lensfed/Provider/adverticement_provider.dart';
import 'package:lensfed/Provider/membershipReniew_provider.dart';
import 'package:lensfed/Services/notification_services.dart';
import 'package:provider/provider.dart';

import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/checkinOut_provider.dart';
import 'package:lensfed/Provider/meeting_provider.dart';
import 'package:lensfed/Provider/member_provider.dart';
import 'package:lensfed/Provider/notication_provider.dart';

import 'package:lensfed/Views/Splash.dart';

/// =====================================================
/// BACKGROUND NOTIFICATION HANDLER
/// =====================================================
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  debugPrint("BACKGROUND MESSAGE RECEIVED");

  final title =
      message.notification?.title ??
      message.data["title"] ??
      "";

  final body =
      message.notification?.body ??
      message.data["body"] ??
      "";

  final date =
      message.data["sendDateTime"] ??
      DateTime.now().toString();

  debugPrint("TITLE => $title");
  debugPrint("BODY => $body");

  await LocalNotificationService.saveNotification(
    title: title,
    body: body,
    date: date,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MemberProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MeetingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CheckinOutProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MembershipreniewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// =====================================================
/// MAIN APP
/// =====================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    /// ONLY KEEP FCM LISTENERS HERE
    /// DO NOT request permission here
    /// Permission popup should show in HomeScreen
    setupFCMListeners();
  }

  /// =====================================================
  /// FCM LISTENERS ONLY
  /// =====================================================
  Future<void> setupFCMListeners() async {
    /// iOS foreground notification support
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// FOREGROUND MESSAGE
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        final title =
            message.notification?.title ??
            message.data["title"] ??
            "";

        final body =
            message.notification?.body ??
            message.data["body"] ??
            "";

        final date =
            message.data["sendDateTime"] ??
            DateTime.now().toString();

        debugPrint("FOREGROUND MESSAGE RECEIVED");

        /// SHOW POPUP
        await LocalNotificationService.showNotification(
          title: title,
          body: body,
        );

        /// SAVE LOCALLY
        await LocalNotificationService.saveNotification(
          title: title,
          body: body,
          date: date,
        );
      },
    );

    /// APP OPENED FROM BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        final title =
            message.notification?.title ??
            message.data["title"] ??
            "";

        final body =
            message.notification?.body ??
            message.data["body"] ??
            "";

        final date =
            message.data["sendDateTime"] ??
            DateTime.now().toString();

        debugPrint("APP OPENED FROM BACKGROUND");

        await LocalNotificationService.saveNotification(
          title: title,
          body: body,
          date: date,
        );
      },
    );

    /// APP OPENED FROM TERMINATED STATE
    RemoteMessage? initialMessage =
        await _messaging.getInitialMessage();

    if (initialMessage != null) {
      final title =
          initialMessage.notification?.title ??
          initialMessage.data["title"] ??
          "";

      final body =
          initialMessage.notification?.body ??
          initialMessage.data["body"] ??
          "";

      final date =
          initialMessage.data["sendDateTime"] ??
          DateTime.now().toString();

      debugPrint("APP OPENED FROM TERMINATED STATE");

      await LocalNotificationService.saveNotification(
        title: title,
        body: body,
        date: date,
      );
    }
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