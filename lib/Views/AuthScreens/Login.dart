import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Views/AuthScreens/Registration.dart';
import 'package:lensfed/Views/HomeScreen.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  void _login() {
    if (_formKey.currentState!.validate()) {

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
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
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(r'\S+@\S+\.\S+')
                              .hasMatch(value)) {
                            return "Invalid email";
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
                                "Remember me",
                                style: TextStyle(
                                    fontSize:
                                        width * 0.035),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                  fontSize:
                                      width * 0.035),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      /// Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.065,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      width * 0.03),
                            ),
                            backgroundColor:
                                const Color(
                                    0xFF6C63FF),
                          ),
                          onPressed: authProvider.isLoading
      ? null
      : () async {

          if (_formKey.currentState!.validate()) {

            bool success = await authProvider.login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );

            if (!context.mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      authProvider.errorMessage ?? "Login failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
                          child:authProvider.isLoading?const CircularProgressIndicator(color: Colors.white)
                           :Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize:
                                  width * 0.04,
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
