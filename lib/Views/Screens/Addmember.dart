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
@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  final isTablet = width > 600;

  return Scaffold(
    backgroundColor: const Color(0xffeef2f7),
    appBar: AppBar(
      toolbarHeight: height * 0.09,
      backgroundColor: const Color(0xff4f46e5),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: width * 0.06,
        ),
      ),
      title: Text(
        "MEMBER",
        style: TextStyle(
          fontSize: width * 0.045,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(width * 0.08),
        ),
      ),
      elevation: 3,
    ),
    body: Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? width * 0.2 : width * 0.05,
          vertical: height * 0.02,
        ),
        child: Container(
          padding: EdgeInsets.all(width * 0.06),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(width * 0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.1),
                blurRadius: width * 0.05,
                offset: Offset(0, height * 0.02),
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Profile Icon
                Center(
                  child: Container(
                    height: width * 0.18,
                    width: width * 0.18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff4f46e5),
                          Color(0xff6366f1),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.verified_user,
                      color: Colors.white,
                      size: width * 0.08,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.025),

                Center(
                  child: Text(
                    "Members",
                    style: TextStyle(
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.01),

                Center(
                  child: Text(
                    "Fill in the details below",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.035,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                buildTextField(context,"Membership ID", membershipIdController),
                buildTextField(context,"Full Name", fullNameController),

                SizedBox(height: height * 0.015),

                Text("Address Details",
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600)),

                SizedBox(height: height * 0.015),

                buildTextField(context,"House Name", houseNameController),
                buildTextField(context,"Place", placeController),
                buildTextField(context,"Post Office", postOfficeController),
                buildTextField(context,"Pin code", pinCodeController),

                SizedBox(height: height * 0.02),

                Text("Office Address (Optional)",
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600)),

                SizedBox(height: height * 0.015),

                buildTextField(context,"Company Name", companyNameController),
                buildTextField(context,"Place", officePlaceController),
                buildTextField(context,"Post Office", officePostOfficeController),
                buildTextField(context,"Pin code", officePinCodeController),

                SizedBox(height: height * 0.02),

                buildTextField(context,"Contact No", contactNoController),
                buildTextField(context,"Whatsapp No", whatsappNoController),
                buildTextField(context,"Email ID", emailController),

                buildTextField(context,"Qualification (Technical)", qualificationController),
                buildTextField(context,"Date of Birth", dobController),
                buildTextField(context,"Age", ageController),
                buildTextField(context,"Blood Group", bloodGroupController),
                buildTextField(context,"District", districtController),
                buildTextField(context,"Area", areaController),
                buildTextField(context,"Unit", unitController),

                buildTextField(context,"Licence Category", licenceCategoryController),
                buildTextField(context,"Licence No", licenceNoController),
                buildTextField(context,"Licence Expiry Date", licenceExpiryController),
                buildTextField(context,"Welfare No", welfareNoController),
                buildTextField(context,"Role", roleController),

                SizedBox(height: height * 0.02),

                DropdownButtonFormField<String>(
                  decoration: inputDecoration(context,"District"),
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

                SizedBox(height: height * 0.04),

                SizedBox(
                  width: double.infinity,
                  height: height * 0.065,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(width * 0.03),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Member Submitted Successfully"),
                          ),
                        );
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff4f46e5),
                            Color(0xff6366f1),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.03)),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: width * 0.04,
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
      bottom: screenWidth * 0.04, 
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