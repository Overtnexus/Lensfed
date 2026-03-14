import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Views/HomeScreen.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String memberId;
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.memberId,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final int otpLength = 6;
  final int resendCooldown = 30;

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  int resendTimer = 30;
  bool verified = false;
  bool otpSent = false;

  String error = "";

  Timer? timer;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < otpLength; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  void startTimer() {

    resendTimer = resendCooldown;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {

      if (resendTimer == 0) {
        t.cancel();
      } else {
        setState(() {
          resendTimer--;
        });
      }

    });
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  /// SEND OTP
  void sendOtp() async {

    final provider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await provider.sendOtp(
      memberId: widget.memberId,
      email: widget.email,
    );

    if (success) {

      setState(() {
        otpSent = true;
        error = "";
      });

      startTimer();

    } else {

      setState(() {
        error = "Failed to send OTP";
      });

    }
  }

  /// VERIFY OTP
  void verifyOtp() async {

    String otp = getOtp();

    if (otp.length < 6) {
      setState(() {
        error = "Please enter complete OTP";
      });
      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await provider.verifyOtp(
      memberId: widget.memberId,
      otp: otp,
    );

    if (success) {

      setState(() {
        verified = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

    } else {

      setState(() {
        error = "Invalid OTP";
      });

      for (var c in controllers) {
        c.clear();
      }

      focusNodes[0].requestFocus();
    }
  }

  /// RESEND OTP
  void resendOtp() async {

    final provider = Provider.of<AuthProvider>(context, listen: false);

    await provider.sendOtp(
      memberId: widget.memberId,
      email: widget.email,
    );

    for (var c in controllers) {
      c.clear();
    }

    focusNodes[0].requestFocus();

    startTimer();
  }

  @override
  void dispose() {

    timer?.cancel();

    for (var c in controllers) {
      c.dispose();
    }

    for (var f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  /// OTP BOX
  Widget otpBox(int index, double size) {

    return SizedBox(
      width: size,
      height: size * 1.3,
      child: TextField(
        enabled: otpSent,
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: size * .45,
          fontWeight: FontWeight.bold,
          height: 1.2
        ),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size * .2),
          ),
        ),
        onChanged: (value) {

          if (value.isNotEmpty && index < otpLength - 1) {
            focusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    double titleSize = w * 0.06;
    double textSize = w * 0.035;
    double iconSize = w * 0.15;
    double otpSize = w * 0.12;
    double buttonHeight = h * 0.06;

    return Scaffold(
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6a11cb), Color(0xff2575fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Container(
            width: w > 500 ? 420 : w * .9,
            padding: EdgeInsets.all(w * 0.05),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(w * 0.04),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black12,
                )
              ],
            ),

            child: verified
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(Icons.check_circle,
                          color: Colors.green, size: iconSize),

                      SizedBox(height: h * .02),

                      Text(
                        "Verified Successfully",
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: h * .01),

                      Text(
                        "Redirecting to dashboard...",
                        style: TextStyle(
                          fontSize: textSize,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  )

                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(Icons.shield_outlined,
                          size: iconSize,
                          color: const Color(0xff2575fc)),

                      SizedBox(height: h * .02),

                      Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: h * .01),

                      Text(
                        "Enter the 6-digit code sent to your email",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: textSize,
                          color: Colors.grey[600],
                        ),
                      ),

                      SizedBox(height: h * .035),

                      /// OTP BOXES
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          otpLength,
                          (index) => otpBox(index, otpSize),
                        ),
                      ),

                      if (error.isNotEmpty) ...[
                        SizedBox(height: h * .02),
                        Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: textSize,
                          ),
                        ),
                      ],

                      SizedBox(height: h * .04),

                      /// SEND OTP
                      if (!otpSent)
                       GestureDetector(
                        onTap: sendOtp,
                        child:  Container(
                      height: h * 0.06,
                      width: w * 0.6,              
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
              
                      child: Center(  
                        child: Text(
                "Send OTP",
                style: getFonts(16, AppColors.accentLight),
              ),
              
                      ),
                    ),
                       ),

                      /// VERIFY BUTTON
                      if (otpSent) ...[
GestureDetector(
                        onTap: verifyOtp,
                        child:  Container(
                      height: h * 0.06,
                      width: w * 0.6,              
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
              
                      child: Center(  
                        child: Text(
                "Verify OTP",
                style: getFonts(16, AppColors.accentLight),
              ),
              
                      ),
                    ),
                       ),

                        SizedBox(height: h * .02),

                        resendTimer > 0
                            ? Text(
                                "Resend OTP in ${resendTimer}s",
                                style: TextStyle(
                                  fontSize: textSize,
                                  color: Colors.grey,
                                ),
                              )
                            : TextButton(
                                onPressed: resendOtp,
                                child: Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],

                      SizedBox(height: h * .02),

                      Divider(color: Colors.grey.shade300),

                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(
                          "Back to Login",
                          style: TextStyle(fontSize: textSize),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}