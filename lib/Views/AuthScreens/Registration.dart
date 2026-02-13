import 'package:flutter/material.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _agreed = false;
  String _role = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (!_agreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must agree to the terms")),
        );
        return;
      }

      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const LoginScreen(),
  ),
);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1000;
    final isDesktop = width >= 1000;
    final horizontalPadding = isMobile ? 20.0 : 40.0;
    final cardWidth = isMobile
        ? double.infinity
        : isTablet
            ? 500.0
            : 650.0;

    final titleSize = isMobile ? 20.0 : 24.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              width: cardWidth,
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 20 : 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: isMobile ? 60 : 70,
                          width: isMobile ? 60 : 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4A47A3)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Join the LensFed community",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 25),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 600) {
                              return _buildTwoColumnLayout();
                            } else {
                              return _buildSingleColumnLayout();
                            }
                          },
                        ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreed,
                              onChanged: (value) {
                                setState(() {
                                  _agreed = value!;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                "I agree to the Terms & Conditions and Privacy Policy",
                                style: TextStyle(fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _register,
                            child: const Text(
                              "Create Account",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
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
  Widget _buildSingleColumnLayout() {
    return Column(
      children: _formFields(),
    );
  }
  Widget _buildTwoColumnLayout() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: _formFields()
          .map((field) => SizedBox(width: 280, child: field))
          .toList(),
    );
  }
  List<Widget> _formFields() {
    return [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: "Full Name",
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Name is required" : null,
      ),
      SizedBox(height: 5,),
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: "Email",
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return "Email required";
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) return "Invalid email";
          return null;
        },
      ),
      SizedBox(height: 5,),
      TextFormField(
        controller: _phoneController,
        decoration: const InputDecoration(
          labelText: "Phone",
          prefixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Phone required" : null,
      ),
      SizedBox(height: 5,),
      DropdownButtonFormField<String>(
        value: _role.isEmpty ? null : _role,
        decoration: const InputDecoration(
          labelText: "Role",
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: "member", child: Text("Member")),
          DropdownMenuItem(value: "club_admin", child: Text("Club Admin")),
          DropdownMenuItem(
              value: "federation_admin", child: Text("Federation Admin")),
        ],
        onChanged: (v) => setState(() => _role = v!),
        validator: (v) => v == null ? "Select role" : null,
      ),
      SizedBox(height: 5,),
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: const Icon(Icons.lock),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        validator: (v) =>
            v!.length < 6 ? "Minimum 6 characters" : null,
      ),
      SizedBox(height: 5,),
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscurePassword,
        decoration: const InputDecoration(
          labelText: "Confirm Password",
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(),
        ),
        validator: (v) =>
            v != _passwordController.text ? "Passwords don't match" : null,
      ),
    ];
  }
}