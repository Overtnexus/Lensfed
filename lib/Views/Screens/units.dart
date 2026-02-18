import 'package:cloud_firestore/cloud_firestore.dart';
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
    final screenWidth = size.width;
final screenHeight = size.height;
    return Scaffold(
  backgroundColor: const Color(0xffeef2f7),
  appBar: AppBar(
    toolbarHeight: screenHeight * 0.09,
    backgroundColor: const Color(0xff4f46e5),
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
        size: screenWidth * 0.06,
      ),
    ),
    title: Center(
      child: Text(
        "UNITS",
        style: getFonts(screenWidth * 0.045, Colors.white),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(screenWidth * 0.07),
      ),
    ),
    elevation: 3,
  ),
  body: Center(
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? screenWidth * 0.2 : screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.06),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius:
              BorderRadius.circular(screenWidth * 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.1),
              blurRadius: screenWidth * 0.05,
              offset: Offset(0, screenHeight * 0.01),
            )
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: screenWidth * 0.18,
                width: screenWidth * 0.18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff4f46e5),
                      Color(0xff6366f1)
                    ],
                  ),
                ),
                child: Icon(
                  Icons.verified_user,
                  color: Colors.white,
                  size: screenWidth * 0.08,
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              Text(
                "Unit",
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.008),

              Text(
                "Fill in the details below to add your Units",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.035,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              buildTextField(
                  context, "Unit Name", _unitNamecontroller),

              buildTextField(
                context,
                "Area",
                _Areacontroller,
              ),

              SizedBox(height: screenHeight * 0.003),

              /// 🔽 Dropdown
              DropdownButtonFormField<String>(
                decoration:
                    inputDecoration(context, "District"),
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
                    value == null ? "Select District" : null,
              ),

              SizedBox(height: screenHeight * 0.04),

              /// 🔵 Submit Button
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.04),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      await FirebaseFirestore.instance.collection("units").add({
        "unit_name": _unitNamecontroller.text.trim(),
        "area": _Areacontroller.text.trim(),
        "district": DistrictMode,
        "created_at": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unit Added Successfully"),
        ),
      );

      _unitNamecontroller.clear();
      _Areacontroller.clear();
      setState(() {
        DistrictMode = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
},
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff4f46e5),
                          Color(0xff6366f1)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.04),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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

 Widget buildTextField(
  BuildContext context,
  String label,
  TextEditingController controller, {
  TextInputType keyboard = TextInputType.text,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.only(
      bottom: screenWidth * 0.04, // responsive spacing
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (value) =>
          value == null || value.isEmpty
              ? "Enter $label"
              : null,
      style: TextStyle(
        fontSize: screenWidth * 0.04, 
      ),
      decoration: inputDecoration(context, label),
    ),
  );
}

 InputDecoration inputDecoration(
    BuildContext context,
    String label,
    ) {

  final screenWidth = MediaQuery.of(context).size.width;

  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      fontSize: screenWidth * 0.035,
    ),
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
          screenWidth * 0.03), 
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.04,
      vertical: screenWidth * 0.035,
    ),
  );
}
}