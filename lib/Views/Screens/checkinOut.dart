import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lensfed/utilities/fonts.dart';

class CheckinOutScreen extends StatefulWidget {
  const CheckinOutScreen({super.key});

  @override
  State<CheckinOutScreen> createState() =>
      _MembershipRenewalScreenState();
}

class _MembershipRenewalScreenState
    extends State<CheckinOutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _meetingschedulecontroller = TextEditingController();
  final TextEditingController _checkindate = TextEditingController();
  final TextEditingController _chechintimecontroller = TextEditingController();
  final TextEditingController _membernamecontroller = TextEditingController();
  final TextEditingController _notescontroller = TextEditingController();

  String? DistrictMode;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _checkindate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  @override
  void initState() {
    _checkindate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }
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
        title: Center(child: Text("CHECK IN/OUT",style: getFonts(18, Colors.white),)),
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
                    "CheckIn/Out",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Fill in the details below to add your CheckIn/Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  buildTextField("Meeting Schedule", _meetingschedulecontroller),
                  buildTextField("Checkin Date", _checkindate,),
        //           Container(
        //   padding: EdgeInsets.symmetric(vertical: 3),
        //          height: screenHeight * 0.042, 
        //       width: screenWidth * 0.42,
        //                             decoration: BoxDecoration(
        //                                border: Border.all(color: Appcolors().searchTextcolor),
        //                               borderRadius: BorderRadius.circular(5),
        //                             ),
        //                             child:  TextField(
        //                               style: getFontsinput(14, Colors.black),
        //    readOnly: true,
        //   controller: _dateController,
        //    decoration: InputDecoration(
        //         border: InputBorder.none,
        //         contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        //       ),
        // ),
        //                           ),
                  buildTextField("Checkin Time", _chechintimecontroller),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration("Select Member"),
                    value: DistrictMode,
                    items: const [
                      DropdownMenuItem(
                          value: "john",
                          child: Text("john")),
                      DropdownMenuItem(
                          value: "kuriyan",
                          child: Text("kuriyan")),
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
                   buildTextField("Notes", _notescontroller),
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