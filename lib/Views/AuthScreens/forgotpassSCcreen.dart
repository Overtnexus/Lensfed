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
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// LOGO
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 35),
                  ),

                  const SizedBox(height: 20),

                  /// TITLE
                  Text(
                    step == 2 ? "Password Updated!" : "Reset Password",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    step == 0
                        ? "Enter your username"
                        : step == 1
                            ? "Enter new password"
                            : "You can now sign in",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  /// STEP 1 FIND USERNAME
                  if (step == 0) ...[
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (error.isNotEmpty)
                      Text(error,
                          style: const TextStyle(color: Colors.red)),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                        child:  Text("Find Account",style: getFonts(width *0.04, AppColors.accentLight),),
                      ),
                    ),
                  ],

                  /// STEP 2 RESET PASSWORD
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

                    const SizedBox(height: 15),

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

                    const SizedBox(height: 15),

                    if (error.isNotEmpty)
                      Text(error,
                          style: const TextStyle(color: Colors.red)),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap:authProvider.isLoading
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
                        height: width * 0.12,
                        width: width * 0.5,  
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientPrimary,
                          borderRadius: BorderRadius.circular(width*0.03)
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Center(child:  Text("Update Password",style: getFonts(width*0.033, AppColors.accentLight),)),
                      ),
                    )

                    
                  ],

                  /// STEP 3 SUCCESS
                  if (step == 2) ...[
                    const Icon(Icons.check_circle,
                        size: 70, color: Colors.green),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                        },
                        child: const Text("Back to Login"),
                      ),
                    ),
                  ],

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back to Sign In"),
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