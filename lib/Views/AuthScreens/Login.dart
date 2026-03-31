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

          final membershipProvider =
              Provider.of<MembershipreniewProvider>(context, listen: false);

          final memberId = _emailController.text.trim();

          try {
            /// 🔥 STEP 1: CHECK MEMBERSHIP FIRST
            final isExpired =
                await membershipProvider.checkMembershipExpired(memberId);

            if (isExpired) {
              /// ❌ STOP LOGIN
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Membership Expired"),
                  content: const Text("Please renew your membership to continue."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    )
                  ],
                ),
              );
              return;
            }

            /// ✅ STEP 2: CONTINUE LOGIN
            bool success = await authProvider.login(
              memberId,
              _passwordController.text.trim(),
            );

            if (!context.mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Verify User",
                    style: getFonts(height * 0.015, Colors.white),
                  ),
                  backgroundColor: AppColors.accentForegroundLight,
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpVerificationScreen(
                    memberId: memberId,
                    email: _MemberidController.text,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid Member ID or Password"),
                  backgroundColor: Colors.red,
                ),
              );
            }

          } catch (e) {
            /// ❌ ERROR HANDLING
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text("Error"),
                content: Text("Unable to verify membership. Try again."),
              ),
            );
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
}
