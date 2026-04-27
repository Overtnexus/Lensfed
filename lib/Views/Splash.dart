import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/membershipReniew_provider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/Views/AuthScreens/subscriptionReniew_screen.dart';
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
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    setState(() => isOffline = false);

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw Exception();
      }
    } catch (_) {
      setState(() => isOffline = true);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    Widget nextScreen = const LoginScreen();

    if (isLoggedIn) {
      final authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      final renewProvider =
          Provider.of<MembershipreniewProvider>(context, listen: false);

      await authProvider.loadUserFromPrefs();

      await renewProvider
          .fetchMembersshipreniew(authProvider.membershipId);

      bool isStillActive = false;

      if (renewProvider.membershipreniew.isNotEmpty) {
        final latest = renewProvider.membershipreniew.first;
        isStillActive = isActive(latest.renewalDate);
      }

      nextScreen =
          isStillActive ? HomeScreen() : const AccountRenewalScreen();
    }

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  bool isActive(String? dateStr) {
    if (dateStr == null || dateStr == "null") return false;

    try {
      DateTime expiry = DateTime.parse(dateStr);
      return expiry.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final width = mq.size.width;
    final height = mq.size.height;

    final isDesktop = width > 1100;
    final isTablet = width > 700 && width <= 1100;

    // Responsive Sizes
    final logoSize = isDesktop
        ? height * 0.14
        : isTablet
            ? height * 0.13
            : height * 0.12;

    final splashTitleSize = isDesktop
        ? width * 0.03
        : isTablet
            ? width * 0.05
            : width * 0.08;

    final offlineTitleSize = isDesktop
        ? width * 0.025
        : isTablet
            ? width * 0.04
            : width * 0.06;

    final subtitleSize = isDesktop
        ? width * 0.014
        : isTablet
            ? width * 0.022
            : width * 0.035;

    final buttonWidth = isDesktop
        ? 220.0
        : isTablet
            ? 200.0
            : 180.0;

    final buttonHeight = isDesktop
        ? 55.0
        : isTablet
            ? 52.0
            : 50.0;

    final iconSize = isDesktop
        ? 100.0
        : isTablet
            ? 90.0
            : 80.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.gradientPrimary,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isOffline
              ? _buildOfflineUI(
                  height,
                  width,
                  offlineTitleSize,
                  subtitleSize,
                  buttonWidth,
                  buttonHeight,
                  iconSize,
                )
              : _buildSplashUI(
                  height,
                  width,
                  logoSize,
                  splashTitleSize,
                ),
        ),
      ),
    );
  }

  Widget _buildOfflineUI(
    double h,
    double w,
    double titleSize,
    double subtitleSize,
    double buttonWidth,
    double buttonHeight,
    double iconSize,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(w * 0.05),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: w * 0.004,
            ),
          ),
          child: Icon(
            Icons.wifi_off_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ),

        SizedBox(height: h * 0.04),

        Text(
          "No Internet Connection",
          style: splashFonts(titleSize).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: h * 0.015),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.1,
          ),
          child: Text(
            "Please check your network settings and try again to access LENSFED.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: subtitleSize,
              height: 1.5,
            ),
          ),
        ),

        SizedBox(height: h * 0.05),

        SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton.icon(
            onPressed: checkLogin,
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: w * 0.05,
            ),
            label: Text(
              "RETRY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: subtitleSize,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  w * 0.06,
                ),
              ),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSplashUI(
    double h,
    double w,
    double logoSize,
    double titleSize,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: h * 0.1),

        Container(
          height: logoSize,
          width: logoSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              logoSize / 2,
            ),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(w * 0.03),
            child: Image.asset(
              "assets/lensfed.logo-removebg.png",
            ),
          ),
        ),

        SizedBox(height: h * 0.025),

        Text(
          "LENSFED",
          style: splashFonts(titleSize),
        ),

        SizedBox(height: h * 0.05),

        SizedBox(
          height: h * 0.04,
          width: h * 0.04,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }
}