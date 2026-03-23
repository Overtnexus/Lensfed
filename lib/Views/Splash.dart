import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/Views/HomeScreen.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LesnsfedSplash extends StatefulWidget {
  const LesnsfedSplash({super.key});

  @override
  State<LesnsfedSplash> createState() => _LesnsfedSplashState();
}

class _LesnsfedSplashState extends State<LesnsfedSplash> {
  Future<void> requestNotificationPermission() async {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("Notification Permission: ${settings.authorizationStatus}");

}

Future<void> getToken() async {

  String? token = await FirebaseMessaging.instance.getToken();

  print("FCM Token: $token");

}



 @override
void initState() {
  super.initState();

  requestNotificationPermission();
  getToken();

  checkLogin();
}
Future<void> checkLogin() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  if (isLoggedIn) {

    /// Load user into provider
    await Provider.of<AuthProvider>(context, listen: false)
        .loadUserFromPrefs();
  }

  await Future.delayed(const Duration(seconds: 3));

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => isLoggedIn ? HomeScreen() : LoginScreen(),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double fontSize1 = screenWidth * 0.07;
    double fontSize2 = screenWidth * 0.06;
    double fontSize3 = screenWidth * 0.03;
    return Scaffold(
       body: Container(
        decoration: BoxDecoration(
          gradient:AppColors.gradientPrimary
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.2),
            Container(
              height: screenHeight * 0.13,
              width: screenHeight * 0.13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenHeight*0.06),
                color: Colors.white
              ),
              child: Image.asset(
                "assets/lensfed.logo-removebg.png",
                height: screenHeight * 0.25, 
              ),
            ),
            Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LENSFED",
                    style: splashFonts(fontSize1), 
                  ),
                  SizedBox(width: 3),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "",
                      style: splash2Fonts(fontSize3), 
                    ),
                    SizedBox(width: 7),
                    Icon(
                      Icons.cloud_off_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}