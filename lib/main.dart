import 'package:flutter/material.dart';
import 'package:lensfed/Views/Screens/Meetings.dart';
import 'package:lensfed/Views/Screens/Membership.dart';
import 'package:lensfed/Views/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MembershipsScreen(),
    );
  }
}
