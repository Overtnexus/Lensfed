import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  int step = 0; // 0=find , 1=reset , 2=done

  final usernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showNew = false;
  bool showConfirm = false;

  String error = "";

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  final isMobile = width < 600;
  final isTablet = width >= 600 && width < 1100;
  final isDesktop = width >= 1100;

  /// 🔹 Dynamic container width
  double containerWidth = isDesktop
      ? width * 0.35
      : isTablet
          ? width * 0.5
          : width * 0.9;

    return Scaffold(
      body: Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.04),

          child: Container(
            width: containerWidth,
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(width * 0.02),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔥 LOGO
                Container(
                  height: width * 0.12,
                  width: width * 0.12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
                    ),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Icon(Icons.camera_alt,
                      color: Colors.white, size: width * 0.06),
                ),

                SizedBox(height: height * 0.02),

                /// 🔥 TITLE
                Text(
                  step == 2 ? "Password Updated!" : "Reset Password",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: height * 0.005),

                Text(
                  step == 0
                      ? "Enter your username"
                      : step == 1
                          ? "Enter new password"
                          : "You can now sign in",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.03,
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// ================= STEP 1 =================
                if (step == 0) ...[
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  if (error.isNotEmpty)
                    Text(error,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: width * 0.03)),

                  SizedBox(height: height * 0.03),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02),
                      ),
                      onPressed: () {
                        if (usernameController.text.trim().isEmpty) {
                          setState(() {
                            error = "Username required";
                          });
                          return;
                        }

                        setState(() {
                          error = "";
                          step = 1;
                        });
                      },
                      child: Text(
                        "Find Account",
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                    ),
                  ),
                ],

                /// ================= STEP 2 =================
                if (step == 1) ...[
                  TextField(
                    controller: newPasswordController,
                    obscureText: !showNew,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNew
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            showNew = !showNew;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirm,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            showConfirm = !showConfirm;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  if (error.isNotEmpty)
                    Text(error,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: width * 0.03)),

                  SizedBox(height: height * 0.03),

                  GestureDetector(
                    onTap: authProvider.isLoading
                        ? null
                        : () async {

                            if (newPasswordController.text.length < 6) {
                              setState(() {
                                error = "Password minimum 6 characters";
                              });
                              return;
                            }

                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              setState(() {
                                error = "Passwords not match";
                              });
                              return;
                            }

                            bool success =
                                await authProvider.updatePassword(
                              memberId:
                                  usernameController.text.trim(),
                              password:
                                  newPasswordController.text.trim(),
                            );

                            if (success) {
                              setState(() {
                                step = 2;
                              });
                            } else {
                              setState(() {
                                error = "Update failed";
                              });
                            }
                          },
                    child: Container(
                      height: height * 0.07,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius:
                            BorderRadius.circular(width * 0.02),
                      ),
                      child: authProvider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          : Center(
                              child: Text(
                                "Update Password",
                                style:
                                    TextStyle(fontSize: width * 0.035),
                              ),
                            ),
                    ),
                  ),
                ],

                /// ================= STEP 3 =================
                if (step == 2) ...[
                  Icon(Icons.check_circle,
                      size: width * 0.15, color: Colors.green),

                  SizedBox(height: height * 0.02),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Back to Login",
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: height * 0.02),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Sign In",
                    style: TextStyle(fontSize: width * 0.03),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  
  }
}