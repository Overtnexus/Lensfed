import 'package:flutter/material.dart';
import 'package:lensfed/utilities/fonts.dart';

class MembershipRenewalScreen extends StatefulWidget {
  const MembershipRenewalScreen({super.key});

  @override
  State<MembershipRenewalScreen> createState() =>
      _MembershipRenewalScreenState();
}

class _MembershipRenewalScreenState
    extends State<MembershipRenewalScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController memberId = TextEditingController();
  final TextEditingController clubName = TextEditingController();
  final TextEditingController renewalYear = TextEditingController();

  String? paymentMode;

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
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back,
            color: Colors.white,
            size: width * 0.06),
      ),
      title: Text(
        "MEMBERSHIP RENEW",
        style: TextStyle(
          fontSize: width * 0.045,
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
              children: [
                Container(
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

                SizedBox(height: height * 0.025),

                Text(
                  "Membership Renewal",
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: height * 0.01),

                Text(
                  "Fill in the details below to renew your membership",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.035,
                  ),
                ),

                SizedBox(height: height * 0.04),

                buildTextField(context, "Full Name", fullName),
                buildTextField(context, "Email Address", email,
                    keyboard: TextInputType.emailAddress),
                buildTextField(context, "Phone Number", phone,
                    keyboard: TextInputType.phone),
                buildTextField(context, "Member ID", memberId),
                buildTextField(context, "Club Name", clubName),
                buildTextField(context, "Renewal Year", renewalYear,
                    keyboard: TextInputType.number),

                SizedBox(height: height * 0.02),

                DropdownButtonFormField<String>(
                  decoration: inputDecoration(context, "Payment Mode"),
                  value: paymentMode,
                  items: const [
                    DropdownMenuItem(
                      value: "Online",
                      child: Text("Online"),
                    ),
                    DropdownMenuItem(
                      value: "Offline",
                      child: Text("Offline"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      paymentMode = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select payment mode" : null,
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
                                "Renewal Submitted Successfully"),
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(width * 0.03),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Submit Renewal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
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