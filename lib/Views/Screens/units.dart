import 'package:flutter/material.dart';
import 'package:lensfed/utilities/fonts.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() =>
      _MembershipRenewalScreenState();
}

class _MembershipRenewalScreenState
    extends State<UnitScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _unitNamecontroller = TextEditingController();
  final TextEditingController _Areacontroller = TextEditingController();
  final TextEditingController _Districtcontroller = TextEditingController();

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
        title: Center(child: Text("UNITS",style: getFonts(18, Colors.white),)),
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
                    "Unit",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Fill in the details below to add your Units",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  buildTextField("Unit Name", _unitNamecontroller),
                  buildTextField("Area", _Areacontroller,
                      keyboard: TextInputType.number),

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