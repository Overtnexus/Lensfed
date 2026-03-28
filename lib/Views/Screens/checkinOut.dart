// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:lensfed/Modals/checkinOut_modal.dart';
// import 'package:lensfed/Modals/meetings_modal.dart';
// import 'package:lensfed/Modals/member_modal.dart';
// import 'package:lensfed/Provider/AuthProvider.dart';
// import 'package:lensfed/Provider/checkinOut_provider.dart';
// import 'package:lensfed/Provider/meeting_provider.dart';
// import 'package:lensfed/Provider/member_provider.dart';
// import 'package:lensfed/utilities/colors.dart';
// import 'package:lensfed/utilities/fonts.dart';
// import 'package:provider/provider.dart';

// class CheckinOutScreen extends StatefulWidget {
//   const CheckinOutScreen({super.key});

//   @override
//   State<CheckinOutScreen> createState() =>
//       _MembershipRenewalScreenState();
// }

// class _MembershipRenewalScreenState
//     extends State<CheckinOutScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _meetingschedulecontroller = TextEditingController();
//   final TextEditingController _checkindate = TextEditingController();
//   final TextEditingController _chechintimecontroller = TextEditingController();
//   final TextEditingController _membernamecontroller = TextEditingController();
//   final TextEditingController _notescontroller = TextEditingController();

//   String? DistrictMode;
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != DateTime.now()) {
//       setState(() {
//         _checkindate.text = DateFormat('dd-MM-yyyy').format(picked);
//       });
//     }
//   }

// Future<void> _selectTime(BuildContext context) async {
//   final TimeOfDay? picked = await showTimePicker(
//     context: context,
//     initialTime: TimeOfDay.now(),
//   );

//   if (picked != null) {
//     final now = DateTime.now();

//     final selectedTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       picked.hour,
//       picked.minute,
//       0, // seconds set manually
//     );

//     setState(() {
//       _chechintimecontroller.text =
//           DateFormat('HH:mm:ss').format(selectedTime);
//     });
//   }
// }
//  final formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     _checkindate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
//     _chechintimecontroller.text =DateFormat('HH:mm:ss').format(DateTime.now());
//       Future.microtask(() =>
//         Provider.of<MemberProvider>(context, listen: false)
//             .fetchMembers());
//             Future.microtask(() =>
//         Provider.of<MeetingProvider>(context, listen: false)
//             .fetchMeeting());
//     super.initState();
//   }
// @override
// Widget build(BuildContext context) {
//   final size = MediaQuery.of(context).size;
//   final width = size.width;
//   final height = size.height;

//   final isTablet = width > 600;
//    final provider =
//             Provider.of<CheckinOutProvider>(context);

//   return Scaffold(
//     backgroundColor: AppColors.backgroundLight,
//     appBar: AppBar(
//       toolbarHeight: height * 0.09,
//       backgroundColor: const Color(0xff4f46e5),
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: Icon(
//           Icons.arrow_back,
//           color: Colors.white,
//           size: width * 0.06,
//         ),
//       ),
//       title: Text(
//         "CHECK IN/OUT",
//         style: TextStyle(
//           fontSize: width * 0.045,
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(width * 0.08),
//         ),
//       ),
//       elevation: 3,
//     ),
//     body: Center(
//       child: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(
//           horizontal: isTablet ? width * 0.2 : width * 0.05,
//           vertical: height * 0.02,
//         ),
//         child: Container(
//           padding: EdgeInsets.all(width * 0.06),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.9),
//             borderRadius: BorderRadius.circular(width * 0.05),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.indigo.withOpacity(0.1),
//                 blurRadius: width * 0.05,
//                 offset: Offset(0, height * 0.02),
//               )
//             ],
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // 🔵 Circle Icon
//                 Container(
//                   height: width * 0.18,
//                   width: width * 0.18,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xff4f46e5),
//                         Color(0xff6366f1),
//                       ],
//                     ),
//                   ),
//                   child: Icon(
//                     Icons.verified_user,
//                     color: Colors.white,
//                     size: width * 0.08,
//                   ),
//                 ),

//                 SizedBox(height: height * 0.025),

//                 Text(
//                   "CheckIn/Out",
//                   style: TextStyle(
//                     fontSize: width * 0.055,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 SizedBox(height: height * 0.01),

//                 Text(
//                   "Fill in the details below to add your CheckIn/Out",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: width * 0.035,
//                   ),
//                 ),

//                 SizedBox(height: height * 0.04),

//                 SizedBox(
//                    width: 330,
//                    child: Consumer<MeetingProvider>(
//                      builder: (context, provider, child) {
//                        return Autocomplete<MeetingModel>(
                        
//                          displayStringForOption: (MeetingModel option) =>
//                              option.meetingName ?? "",
//                           optionsViewBuilder: (context, onSelected, options) {
//   return Align(
//     alignment: Alignment.topLeft,
//     child: Material(
//       color: Colors.grey.shade200, 
//       child: SizedBox(
//         width: 330,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: options.length,
//           itemBuilder: (context, index) {
//             final member = options.elementAt(index);
//             return ListTile(
//               title: Text(member.meetingName ?? ""),
//               onTap: () => onSelected(member),
//             );
//           },
//         ),
//       ),
//     ),
//   );
// },
//                          optionsBuilder: (TextEditingValue textEditingValue) {
//                            if (textEditingValue.text.isEmpty) {
//                              return provider.meeting;
//                            }
//                            return provider.meeting.where((MeetingModel member) {
//                              return (member.meetingName ?? "")
//                                  .toLowerCase()
//                                  .contains(textEditingValue.text.toLowerCase());
//                            });
//                          },
                 
//                          onSelected: (MeetingModel selection) {
//                            _meetingschedulecontroller.text = selection.meetingName ?? "";
//                          },
                 
//                          fieldViewBuilder:
//                              (context, textEditingController, focusNode, onEditingComplete) {
//                            textEditingController.text = _meetingschedulecontroller.text;
                 
//                            return TextFormField(
//                              controller: textEditingController,
//                              focusNode: focusNode,
//                              decoration: inputDecoration(context,"Meeting Name"),
//                              validator: (value) =>
//                                  value == null || value.isEmpty
//                                      ? "Required"
//                                      : null,
//                            );
//                          },
//                        );
//                      },
//                    ),
//                  ),
//                   SizedBox(height: height * 0.02),
//                 buildTextField(
//                     context, "Checkin Date", _checkindate),
//                 buildTextField(context, "Checkin Time",
//                     _chechintimecontroller),

//                 SizedBox(height: height * 0.001),

//                  SizedBox(
//                    width: 330,
//                    child: Consumer<MemberProvider>(
//                      builder: (context, provider, child) {
//                        return Autocomplete<MembersModal>(
                        
//                          displayStringForOption: (MembersModal option) =>
//                              option.fullName ?? "",
//                           optionsViewBuilder: (context, onSelected, options) {
//   return Align(
//     alignment: Alignment.topLeft,
//     child: Material(
//       color: Colors.grey.shade200, 
//       child: SizedBox(
//         width: 330,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: options.length,
//           itemBuilder: (context, index) {
//             final member = options.elementAt(index);
//             return ListTile(
//               title: Text(member.fullName ?? ""),
//               onTap: () => onSelected(member),
//             );
//           },
//         ),
//       ),
//     ),
//   );
// },
//                          optionsBuilder: (TextEditingValue textEditingValue) {
//                            if (textEditingValue.text.isEmpty) {
//                              return provider.members;
//                            }
//                            return provider.members.where((MembersModal member) {
//                              return (member.fullName ?? "")
//                                  .toLowerCase()
//                                  .contains(textEditingValue.text.toLowerCase());
//                            });
//                          },
                 
//                          onSelected: (MembersModal selection) {
//                            _membernamecontroller.text = selection.fullName ?? "";
//                          },
                 
//                          fieldViewBuilder:
//                              (context, textEditingController, focusNode, onEditingComplete) {
//                            textEditingController.text = _membernamecontroller.text;
                 
//                            return TextFormField(
//                              controller: textEditingController,
//                              focusNode: focusNode,
//                              decoration: inputDecoration(context,"Member Name"),
//                              validator: (value) =>
//                                  value == null || value.isEmpty
//                                      ? "Required"
//                                      : null,
//                            );
//                          },
//                        );
//                      },
//                    ),
//                  ),

//                 SizedBox(height: height * 0.017),

//                 buildTextField(
//                     context, "Notes", _notescontroller),

//                 SizedBox(height: height * 0.04),

//                 // 🔵 Submit Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: height * 0.065,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(width * 0.03),
//                       ),
//                       padding: EdgeInsets.zero,
//                     ),
//                    onPressed: provider.isLoading
//     ? null
//     : () async {
//         if (_formKey.currentState!.validate()) {

//           final checkin = CheckinoutModal(
//             meetingSchedule: _meetingschedulecontroller.text,
//             checkinDate: _checkindate.text,
//             checkinTime: _chechintimecontroller.text,
//             member: _membernamecontroller.text,
//             notes: _notescontroller.text,
//             createdBY: "member",
//           );

//           await provider.addCheckinout(checkin);

//           Fluttertoast.showToast(msg: "Added Successfully");

//           setState(() {
//             _meetingschedulecontroller.clear();
//             _checkindate.text =
//                 DateFormat('dd-MM-yyyy').format(DateTime.now());
//             _chechintimecontroller.text =
//                 DateFormat('HH:mm:ss').format(DateTime.now());
//             _notescontroller.clear();
//             DistrictMode = null;
//           });

//           Navigator.pop(context);
//         }
//       },
//                     child: provider.isLoading ?
//                     CircularProgressIndicator(color: Colors.white,)
//                     : Ink(
//                       decoration: BoxDecoration(
//                         gradient: AppColors.gradientPrimary,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(width * 0.03),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(
//                             fontSize: width * 0.04,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

//  Widget buildTextField(
//   BuildContext context,
//   String label,
//   TextEditingController controller, {
//   TextInputType keyboard = TextInputType.text,
// }) {
//   final screenWidth = MediaQuery.of(context).size.width;

//   return Padding(
//     padding: EdgeInsets.only(
//       bottom: screenWidth * 0.04, // responsive spacing
//     ),
//     child: TextFormField(
//       controller: controller,
//       keyboardType: keyboard,
//       validator: (value) =>
//           value == null || value.isEmpty
//               ? "Enter $label"
//               : null,
//       style: TextStyle(
//         fontSize: screenWidth * 0.04, 
//       ),
//       decoration: inputDecoration(context, label),
//     ),
//   );
// }

//  InputDecoration inputDecoration(
//     BuildContext context,
//     String label,
//     ) {

//   final screenWidth = MediaQuery.of(context).size.width;

//   return InputDecoration(
//     labelText: label,
//     labelStyle: TextStyle(
//       fontSize: screenWidth * 0.035,
//     ),
//     filled: true,
//     fillColor: Colors.grey.shade100,
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(
//           screenWidth * 0.03), 
//       borderSide: BorderSide.none,
//     ),
//     contentPadding: EdgeInsets.symmetric(
//       horizontal: screenWidth * 0.04,
//       vertical: screenWidth * 0.035,
//     ),
//   );
// }
//   InputDecoration inputDecoration2(String label, [String? hint, IconData? icon]) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//   return InputDecoration(
//     labelText: label,
//     hintText: hint,
//     prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600) : null,

//     filled: true,
//     fillColor: Colors.grey.shade100,

//     contentPadding: const EdgeInsets.symmetric(
//       horizontal: 20,
//       vertical: 18,
//     ),

//     labelStyle: formFonts(h * 0.025, Colors.grey),

//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(
//         width: h * 0.002,
//         color: Colors.grey.shade400,
//       ),
//     ),

//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(
//         color: Color(0xFF7C3AED),
//         width: 1.8,
//       ),
//     ),

//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//   );
// }
// }