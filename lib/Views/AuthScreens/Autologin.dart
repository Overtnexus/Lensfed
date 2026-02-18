import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Views/HomeScreen.dart';
import 'package:lensfed/Views/Splash.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.userData!= null) {
      return const HomeScreen();
    } else {
      return const LesnsfedSplash();
    }
  }
}