import 'package:flutter/material.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/Views/AuthScreens/Registration.dart';
import 'package:lensfed/Views/HomeScreen.dart';
import 'package:lensfed/utilities/fonts.dart';

class LesnsfedSplash extends StatefulWidget {
  const LesnsfedSplash({super.key});

  @override
  State<LesnsfedSplash> createState() => _LesnsfedSplashState();
}

class _LesnsfedSplashState extends State<LesnsfedSplash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0616BA),
              Color(0xFF387FE9),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.2),
            // Container(
            //   child: Image.asset(
            //     "assets/images/launch 1.png",
            //     height: screenHeight * 0.25, 
            //   ),
            // ),
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