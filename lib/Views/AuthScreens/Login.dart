import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/membershipReniew_provider.dart';
import 'package:lensfed/Views/AuthScreens/Registration.dart';
import 'package:lensfed/Views/AuthScreens/forgotPass_otp.dart';
import 'package:lensfed/Views/AuthScreens/forgotpassSCcreen.dart';
import 'package:lensfed/Views/AuthScreens/otp_verifyScreen.dart';
import 'package:lensfed/Views/HomeScreen.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  final TextEditingController _MemberidController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  void _login() {
    if (_formKey.currentState!.validate()) {

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
  }

  void showDialogBox(String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 20,
      child: Container(
        width: 380, // Fixed width for consistent look
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Premium Gradient Header ---
            Container(
              height: 10,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                gradient: LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)], // Warning/Error orange-red gradient
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
              child: Column(
                children: [
                  // --- Alert Icon Section ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3F2), // Light red bg
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning_amber_rounded, size: 40, color: Color(0xFFEF4444)),
                  ),
                  const SizedBox(height: 24),
                  
                  // --- Message Text ---
                  const Text(
                    "MEMBERSHIP EXPIRED",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF101828), letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message, // Passing "Membership expired. Please renew."
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF667085), height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  
                  // --- Premium Gradient Action Button ---
                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(colors: [Color(0xFF7B61FF), Color(0xFF4A90E2)]),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF7B61FF).withOpacity(0.35), blurRadius: 15, offset: const Offset(0, 6))
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "RENEW NOW", 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
@override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  final isTablet = width > 600;

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
          padding: EdgeInsets.all(width * 0.05),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? width * 0.5 : width,
            ),
            child: Card(
              elevation: width * 0.03,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// Logo
                      Container(
                        height: width * 0.18,
                        width: width * 0.18,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6C63FF),
                              Color(0xFF4A47A3)
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(width * 0.05),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: width * 0.09,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      Text(
                        "Welcome to LensFed",
                        style: TextStyle(
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.008),

                      Text(
                        "Sign in to your account",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: width * 0.035,
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      /// Email
                      TextFormField(
  controller: _emailController,
  decoration: const InputDecoration(
    labelText: "Member ID",
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Member ID is required";
    }
    return null;
  },
),
 SizedBox(height: height * 0.025),
                TextFormField(
  controller: _MemberidController,
  decoration: const InputDecoration(
    labelText: "Email",
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Member ID is required";
    }
    return null;
  },
),

                      SizedBox(height: height * 0.025),

                      /// Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon:
                              const Icon(Icons.lock),
                          border:
                              const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: width * 0.05,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: height * 0.02),

                      /// Remember Me + Forgot
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe =
                                        value ?? false;
                                  });
                                },
                              ),
                              Text(
                                "Remember Me",
                                style: TextStyle(
                                    fontSize:
                                        width * 0.035),
                              ),
                            ],
                          ),
                         TextButton(
  onPressed: () {

    if (_MemberidController.text.trim().isEmpty&&_emailController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          backgroundColor: AppColors.accentForegroundLight,
          content: Text("Please enter Email & MemberID first",style: getFonts(height*0.015, Colors.white),),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ForgotOtpVerificationScreen(
          memberId: _MemberidController.text,
          email: _emailController.text,
        ),
      ),
    );

  },
  child: Text(
    "Forgot password?",
    style: TextStyle(fontSize: width * 0.035),
  ),
),
                        ],
                      ),

                      SizedBox(height: height * 0.02),
                      GestureDetector(
                      onTap: authProvider.isLoading
    ? null
    : () async {
        if (_formKey.currentState!.validate()) {
          final membershipProvider = Provider.of<MembershipreniewProvider>(context, listen: false);
          
          // Using the correct controller for Member ID
          final memberId = _emailController.text.trim();
          final password = _passwordController.text.trim();

          try {
            /// 1. PRE-CHECK: Verify if the account is expired before attempting login
            /// This prevents the "Invalid credentials" error if the account is locked/expired
            final isExpired = await membershipProvider.checkMembershipExpired(memberId);

            if (isExpired) {
              // Show the beautiful dialog and STOP the process
              showPremiumExpiredDialog("Your LENSFED membership has expired on the system. Please renew your subscription to continue using the dashboard.");
              return; 
            }

            /// 2. PROCEED TO LOGIN
            bool success = await authProvider.login(memberId, password);

            if (!context.mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Authentication Successful. Verifying..."),
                  backgroundColor: const Color(0xFF10B981), // Emerald
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpVerificationScreen(
                    memberId: memberId,
                    email: _MemberidController.text.trim(), // Assuming this is the Email field
                  ),
                ),
              );
            } else {
              // Only show this if the credentials are actually wrong
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid Member ID or Password"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }

          } catch (e) {
            // Handle network or unexpected errors
            showPremiumExpiredDialog("Unable to verify membership. Please check your internet connection and try again.");
          }
        }
      },
                        child:  Container(
                      height: height * 0.06,
                      width: width * 0.6,              
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(height * 0.02),
                      ),
              
                      child: Center(  
                        child:authProvider.isLoading?const CircularProgressIndicator(color: Colors.white)
                           : Text(
                "Sign IN",
                style: getFonts(16, AppColors.accentLight),
              ),
              
                      ),
                    ),
                       ),

                      SizedBox(height: height * 0.03),

                      /// Register
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontSize:
                                    width * 0.035),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize:
                                    width * 0.035,
                                color: const Color(
                                    0xFF6C63FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
void showPremiumExpiredDialog(String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "MEMBERSHIP EXPIRED",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF1E1B4B), // Dark Navy
                    letterSpacing: 0.8
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 32),
                
                // RENEW BUTTON (Emerald Gradient)
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      "PROCEED TO RENEWAL", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Maybe Later", style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                )
              ],
            ),
          ),
          
          // FLOATING ICON CIRCLE (LENSFED Violet)
          Positioned(
            top: -40,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED), 
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 6),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.3), blurRadius: 15)
                ],
              ),
              child: const Icon(Icons. hourglass_disabled_rounded, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    ),
  );
}
}
