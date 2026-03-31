import 'package:flutter/material.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/utilities/colors.dart';

class AccountRenewalScreen extends StatelessWidget {
  const AccountRenewalScreen({super.key});

  final Color emeraldGreen = const Color(0xFF10B981);
  final Color amberOrange = const Color(0xFFFBBF24);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Beautiful Illustration/Icon
              Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: amberOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.timer_off_outlined, 
                    size: 80, color: amberOrange),
                ),
              ),
              const SizedBox(height: 40),
              
              // Text Content
              const Text(
                "Membership Expired",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 15),
              Text(
                "Your account subscription has ended. Please renew your membership to continue accessing your dashboard and services.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 50),

              // Action Button (Emerald Green)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Logic to open payment gateway or contact admin
                  },
                  child: const Text("RENEW MEMBERSHIP NOW", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Logout/Back Button
              TextButton(
                onPressed: () {
                  // Logout logic
                  Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: Text("Sign in as different user", 
                  style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
              ),

              const Spacer(),
              
              // Support Info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("Need help? Contact Admin", 
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}