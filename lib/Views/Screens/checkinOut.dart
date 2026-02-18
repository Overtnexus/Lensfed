import 'package:cloud_firestore/cloud_firestore.dart';
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
        _checkindate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    final now = DateTime.now();

    final selectedTime = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
      0, // seconds set manually
    );

    setState(() {
      _chechintimecontroller.text =
          DateFormat('HH:mm:ss').format(selectedTime);
    });
  }
}

  @override
  void initState() {
    _checkindate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _chechintimecontroller.text =DateFormat('HH:mm:ss').format(DateTime.now());
    super.initState();
  }
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
        "CHECK IN/OUT",
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
              children: [
                // 🔵 Circle Icon
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
                  "CheckIn/Out",
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: height * 0.01),

                Text(
                  "Fill in the details below to add your CheckIn/Out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.035,
                  ),
                ),

                SizedBox(height: height * 0.04),

                buildTextField(context, "Meeting Schedule",
                    _meetingschedulecontroller),
                buildTextField(
                    context, "Checkin Date", _checkindate),
                buildTextField(context, "Checkin Time",
                    _chechintimecontroller),

                SizedBox(height: height * 0.001),

                DropdownButtonFormField<String>(
                  decoration:
                      inputDecoration(context, "Select Member"),
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
                      value == null ? "Select District" : null,
                ),

                SizedBox(height: height * 0.017),

                buildTextField(
                    context, "Notes", _notescontroller),

                SizedBox(height: height * 0.04),

                // 🔵 Submit Button
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
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        try{
                          await FirebaseFirestore.instance.collection("checkinOut").add({
                            "meeting_schedule":_meetingschedulecontroller.text.trim(),
                            "checkin_date":_checkindate.text.trim(),
                            "checkin_time":_chechintimecontroller.text.trim(),
                            "member":_membernamecontroller.text.trim(),
                            "notes":_notescontroller.text.trim(),
                            "created_at":TimeOfDay.now(),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Added Successfully"))
                          );
   
                          _meetingschedulecontroller.clear();
                          _membernamecontroller.clear();
                          _notescontroller.clear();
                        }catch (e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("error :$e"))
                          );
                        }
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