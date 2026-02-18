import 'package:flutter/material.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:provider/provider.dart';

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
@override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  final isMobile = width < 600;

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
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width * 0.9,
            ),
            child: Card(
              elevation: width * 0.03,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(width * 0.04),
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
                        height: width * 0.15,
                        width: width * 0.15,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6C63FF),
                              Color(0xFF4A47A3)
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  width * 0.04),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: width * 0.07,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: height * 0.008),

                      Text(
                        "Join the LensFed community",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: width * 0.035,
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      /// Responsive Layout
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >
                              width * 0.7) {
                            return _buildTwoColumnLayout(context);
                          } else {
                            return _buildSingleColumnLayout();
                          }
                        },
                      ),

                      SizedBox(height: height * 0.03),

                      Row(
                        children: [
                          Checkbox(
                            value: _agreed,
                            onChanged: (value) {
                              setState(() {
                                _agreed = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              "I agree to the Terms & Conditions and Privacy Policy",
                              style: TextStyle(
                                  fontSize:
                                      width * 0.032),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: height * 0.03),

                      SizedBox(
                        width: double.infinity,
                        height: height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF6C63FF),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      width * 0.03),
                            ),
                          ),
                          onPressed: authProvider.isLoading
      ? null
      : () async {
          if (_formKey.currentState!.validate()) {

            if (_passwordController.text != _confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Passwords do not match"),
                ),
              );
              return;
            }

            bool success = await authProvider.register(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              fullName: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              role: _role
            );

            if (!context.mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account created successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      authProvider.errorMessage ?? "Registration failed"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
                          child: authProvider.isLoading?CircularProgressIndicator(
                            color: Colors.white,
                          )
                          : Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: width * 0.04,
                            ),
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
Widget _buildTwoColumnLayout(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return Wrap(
    spacing: width * 0.04,     
    runSpacing: width * 0.04,    
    children: _formFields()
        .map(
          (field) => SizedBox(
            width: width * 0.4,   
            child: field,
          ),
        )
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
      SizedBox(
  height: MediaQuery.of(context).size.height * 0.006,
),
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
      SizedBox(
  height: MediaQuery.of(context).size.height * 0.006,
),
      TextFormField(
        controller: _phoneController,
        decoration: const InputDecoration(
          labelText: "Phone",
          prefixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Phone required" : null,
      ),
      SizedBox(
  height: MediaQuery.of(context).size.height * 0.006,
),
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
     SizedBox(
  height: MediaQuery.of(context).size.height * 0.006,
),
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
