import 'package:flutter/material.dart';
import 'package:lensfed/utilities/fonts.dart';

class AddmemberScreen extends StatefulWidget {
  const AddmemberScreen({super.key});

  @override
  State<AddmemberScreen> createState() =>
      _MembershipRenewalScreenState();
}

class _MembershipRenewalScreenState
    extends State<AddmemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController membershipIdController = TextEditingController();
final TextEditingController fullNameController = TextEditingController();

/// Address
final TextEditingController houseNameController = TextEditingController();
final TextEditingController placeController = TextEditingController();
final TextEditingController postOfficeController = TextEditingController();
final TextEditingController pinCodeController = TextEditingController();

/// Office Address
final TextEditingController companyNameController = TextEditingController();
final TextEditingController officePlaceController = TextEditingController();
final TextEditingController officePostOfficeController = TextEditingController();
final TextEditingController officePinCodeController = TextEditingController();

/// Contact Details
final TextEditingController contactNoController = TextEditingController();
final TextEditingController whatsappNoController = TextEditingController();
final TextEditingController emailController = TextEditingController();

/// Personal Details
final TextEditingController qualificationController = TextEditingController();
final TextEditingController dobController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController bloodGroupController = TextEditingController();
final TextEditingController districtController = TextEditingController();
final TextEditingController areaController = TextEditingController();
final TextEditingController unitController = TextEditingController();

/// License Details
final TextEditingController licenceCategoryController = TextEditingController();
final TextEditingController licenceNoController = TextEditingController();
final TextEditingController licenceExpiryController = TextEditingController();
final TextEditingController welfareNoController = TextEditingController();
final TextEditingController roleController = TextEditingController();

  String? DistrictMode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xffeef2f7),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xff4f46e5),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Center(child: Text("MEMBER",style: getFonts(18, Colors.white),)),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
       bottom: Radius.circular(30),
        ),
       ),
       elevation: 3,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: isTablet ? size.width * 0.2 : 20,
              vertical: 40),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff4f46e5),
                          Color(0xff6366f1)
                        ],
                      ),
                    ),
                    child: const Icon(Icons.verified_user,
                        color: Colors.white, size: 32),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Members",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Fill in the details below",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                 buildTextField("Membership ID", membershipIdController),
buildTextField("Full Name", fullNameController),

SizedBox(height: 5),
Text("Address Details", style: getFonts(15, Colors.black)),

buildTextField("House Name", houseNameController),
buildTextField("Place", placeController),
buildTextField("Post Office", postOfficeController),
buildTextField("Pin code", pinCodeController),

SizedBox(height: 5),
Text("Office Address (Optional)", style: getFonts(15, Colors.black)),

buildTextField("Company Name", companyNameController),
buildTextField("Place", officePlaceController),
buildTextField("Post Office", officePostOfficeController),
buildTextField("Pin code", officePinCodeController),


SizedBox(height: 5),

buildTextField("Contact No", contactNoController),
buildTextField("Whatsapp No", whatsappNoController),
buildTextField("Email ID", emailController),

buildTextField("Qualification (Technical)", qualificationController),
buildTextField("Date of Birth", dobController),
buildTextField("Age", ageController),
buildTextField("Blood Group", bloodGroupController),
buildTextField("District", districtController),
buildTextField("Area", areaController),
buildTextField("Unit", unitController),

buildTextField("Licence Category", licenceCategoryController),
buildTextField("Licence No", licenceNoController),
buildTextField("Licence Expiry Date", licenceExpiryController),
buildTextField("Welfare No", welfareNoController),
buildTextField("Role", roleController),
                  const SizedBox(height: 16),

                  // 🔽 Dropdown
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration("District"),
                    value: DistrictMode,
                    items: const [
                      DropdownMenuItem(
                          value: "Trissur",
                          child: Text("Trissur")),
                      DropdownMenuItem(
                          value: "Malappuram",
                          child: Text("Malappuram")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        DistrictMode = value;
                      });
                    },
                    validator: (value) =>
                        value == null
                            ? "Select District"
                            : null,
                  ),

                  const SizedBox(height: 24),

                  // 🔵 Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12)),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!
                            .validate()) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Renewal Submitted Successfully"),
                            ),
                          );
                        }
                      },
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff4f46e5),
                              Color(0xff6366f1)
                            ],
                          ),
                          borderRadius:
                              BorderRadius.all(
                                  Radius.circular(12)),
                        ),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w600),
                          ),
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
    );
  }

  Widget buildTextField(String label,
      TextEditingController controller,
      {TextInputType keyboard =
          TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) =>
            value == null || value.isEmpty
                ? "Enter $label"
                : null,
        decoration: inputDecoration(label),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      contentPadding:
          const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
    );
  }
}