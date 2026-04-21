import 'package:flutter/material.dart';
import 'package:lensfed/Modals/member_modal.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/member_provider.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _memberIdController =
      TextEditingController();
  final TextEditingController _memberNameController =
      TextEditingController();
      final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  @override
  void initState() {
    super.initState();
             Future.microtask(() =>
        Provider.of<MemberProvider>(context, listen: false)
            .fetchMembers());
  }
  @override
  Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    InputDecoration inputDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.symmetric(
          vertical: height * 0.022,
          horizontal: width * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
      );
    }

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
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 8,
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
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: height * 0.04),

                        /// MEMBER ID
                        SizedBox(
                          child:Consumer<MemberProvider>(
  builder: (context, provider, child) {
    return Autocomplete<MembersModal>(
      displayStringForOption: (option) =>
          option.membershipId ?? "",

      optionsBuilder: (TextEditingValue textEditingValue) {
        if (provider.members.isEmpty) {
          return const Iterable<MembersModal>.empty();
        }

        return provider.members.where((member) {
          final id = member.membershipId ?? "";
          final name = member.fullName ?? "";
          final query = textEditingValue.text.toLowerCase();

          return id.toLowerCase().contains(query) ||
              name.toLowerCase().contains(query);
        });
      },

      onSelected: (selection) {
        _memberIdController.text = selection.membershipId ?? "";
        _memberNameController.text = selection.fullName ?? "";
      },

      fieldViewBuilder:
          (context, textEditingController, focusNode, onEditingComplete) {

        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration:
              inputDecoration("Member ID", Icons.badge),
          validator: (value) =>
              value == null || value.isEmpty
                  ? "Member ID required"
                  : null,
        );
      },

      // 🔥 THIS FIXES DROPDOWN NOT SHOWING
      optionsViewBuilder:
          (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: Container(
              width: 300,
              constraints:
                  const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option =
                      options.elementAt(index);

                  return ListTile(
                    title: Text(
                        option.membershipId ?? ""),
                    subtitle:
                        Text(option.fullName ?? ""),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  },
)
                        ),

                        SizedBox(height: height * 0.025),

                        /// MEMBER NAME
                        TextFormField(
                          controller: _memberNameController,
                          decoration: inputDecoration(
                              "Member Name", Icons.person),
                          validator: (v) =>
                              v == null || v.isEmpty
                                  ? "Member Name required"
                                  : null,
                        ),
                        SizedBox(height: height * 0.025),
                        TextFormField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: inputDecoration(
    "Email Address",
    Icons.email_outlined,
  ),
  validator: (value) {

    if (value == null || value.isEmpty) {
      return "Please enter email";
    }

    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }

    return null;
  },
),

                        SizedBox(height: height * 0.025),

                        /// PASSWORD
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: inputDecoration(
                                  "Create Password", Icons.lock)
                              .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword =
                                      !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Password required";
                            }
                            if (v.length < 6) {
                              return "Minimum 6 characters";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: height * 0.025),

                        /// CONFIRM PASSWORD
                        TextFormField(
                          controller:
                              _confirmPasswordController,
                          obscureText: _obscurePassword,
                          decoration: inputDecoration(
                              "Confirm Password",
                              Icons.lock_outline),
                          validator: (v) {
                            if (v !=
                                _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: height * 0.04),

                        /// REGISTER BUTTON
                         GestureDetector(
                      onTap: authProvider.isLoading
        ? null
        : () async {
            if (_formKey.currentState!.validate()) {

              if (_passwordController.text !=
                  _confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Passwords do not match"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              bool success = await authProvider.register(
                memberId: _memberIdController.text.trim(),
                fullName: _memberNameController.text.trim(),
                password: _passwordController.text.trim(),
                email: _emailController.text.trim(),
              );

              if (!context.mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Registration Successful"),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Registration Failed"),
                    backgroundColor: Colors.red,
                  ),
                );
                String displayError = "Registration Failed";
                 if (authProvider.errorMessage == "Member ID already exists") {
              displayError = "Already Exist Member";
            } else if (authProvider.errorMessage != null) {
              displayError = authProvider.errorMessage!;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(displayError),
                backgroundColor: Colors.red,
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
                "REGISTER",
                style: getFonts(16, AppColors.accentLight),
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
}