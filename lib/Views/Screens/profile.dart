import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lensfed/Modals/member_modal.dart';
import 'package:lensfed/Modals/membershipReniew_modal.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Provider/member_provider.dart';
import 'package:lensfed/Provider/membershipReniew_provider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/utilities/colors.dart';
import 'package:lensfed/utilities/fonts.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
 Future.microtask(() {
    final auth =
        Provider.of<AuthProvider>(context, listen: false);
    Provider.of<MembershipreniewProvider>(context, listen: false)
        .fetchMembersshipreniew(auth.membershipId);
  });

    Future.microtask(() {
      Provider.of<MemberProvider>(context, listen: false)
          .fetchMembers();
    });
    
  }

  bool isActive(String? renewalDate) {
  if (renewalDate == null || renewalDate == "null") return false;
  try {
    DateTime expiry = DateTime.parse(renewalDate); 
    return expiry.isAfter(DateTime.now());
  } catch (e) {
    return false;
  }
}

  @override
  Widget build(BuildContext context) {

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final authProvider = Provider.of<AuthProvider>(context);
    final memberProvider = Provider.of<MemberProvider>(context);
    final reniewProvider = Provider.of<MembershipreniewProvider>(context);

    final user = authProvider.membershipId;

    /// ✅ MATCH LOGGED USER
    MembersModal? currentMember;

    if (memberProvider.members.isNotEmpty && user != null) {
      currentMember = memberProvider.members.firstWhere(
        (m) =>
            (m.membershipId ?? "").trim().toLowerCase() ==
            (user?? "").trim().toLowerCase(),
        orElse: () => memberProvider.members.first,
      );
      
    }

    /// LOADING
    if (memberProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// EMPTY
    if (currentMember == null) {
      return const Scaffold(
        body: Center(child: Text("No Matching User Found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// PROFILE CARD
              Stack(
                clipBehavior: Clip.none,
                children:[
                   Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius:w * 0.025,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),

                  child: Column(
                    children: [
                
                      /// 🔵 TOP GRADIENT SECTION
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w*0.02),
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:  BorderRadius.vertical(
                            top: Radius.circular(w * 0.05),
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xff7b61ff), Color(0xff4f8cff)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: w * 0.10,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: w * 0.087,
                                backgroundColor: const Color(0xff6c63ff),
                                child: Text(
                                  (currentMember.fullName ?? "U")[0]
                                                    .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: w*0.02,),
                            Container(
                              width: w*0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: Text(
                                                        currentMember.fullName ?? "-",
                                                        style: getFonts(w*0.04, Colors.white)
                                                      ),
                                  ),
                                         
                                ],
                              ),
                            ),
                            SizedBox(width: w*0.02,),
                            IconButton(onPressed: (){
                              Provider.of<AuthProvider>(context, listen: false).logout3(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                            }, icon: Icon(Icons.logout,size: w*0.09,color: AppColors.accentLight,))
                          ],
                        ),
                      ),
                
                      /// ⚪ BOTTOM CONTENT
                      Container(
                        width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
  w * 0.04,   // 16
  h * 0.012,  // 10
  w * 0.04,   // 16
  h * 0.02,   // 16
),
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(w * 0.05),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      Text(
                                                    "MemberID : ${currentMember.membershipId}",
                                                    style: getFonts(w*0.03, Colors.black)
                                                  ),
                           
                            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                       Row(
                children: [
                  Container(
                    padding:  EdgeInsets.symmetric(
                        horizontal:  w * 0.025, vertical: h * 0.005),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(w * 0.05),
                    ),
                    child: Text(
                      currentMember.role ?? "Member",
                      style:  TextStyle(
                        color: Colors.purple,
                        fontSize:  h * 0.013,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                
                  const SizedBox(width: 8),
                Consumer<MembershipreniewProvider>(
  builder: (context, provider, child) {

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.membershipreniew.isEmpty) {
      return const Text("No Renewal Data Found");
    }

    /// ✅ FILTER LATEST PER MEMBER
    Map<String, dynamic> latestMap = {};

    for (var item in provider.membershipreniew) {
      final key = item.memberId ?? "";

      if (!latestMap.containsKey(key)) {
        latestMap[key] = item;
      } else {
        final existing = latestMap[key];

        final existingDate =
            DateTime.tryParse(existing.renewalDate ?? "") ?? DateTime(2000);

        final newDate =
            DateTime.tryParse(item.renewalDate ?? "") ?? DateTime(2000);

        if (newDate.isAfter(existingDate)) {
          latestMap[key] = item;
        }
      }
    }

    final latestList = latestMap.values.toList();

    return Column(
      children: latestList
          .map((e) => buildActiveCard(e))
          .toList(),
    );
  },
)
                
                 
                ],
                            ),
                
                  GestureDetector(
                    onTap: () {
                      openEditDialog(context, currentMember!);
                    },
                    child: Container(
                      width: w*0.2,
                      height: w*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w*0.02),
                        gradient: AppColors.gradientPrimary,
                    
                    
                      ),
                      child: Center(
                        child: Text("Edit",style: getFonts(w*0.032, AppColors.accentLight),),
                      ),
                    ),
                  )
                ],
                            ),
                                           
                          ],
                        ),
                      ),
                
                      /// 👤 AVATAR (OVERLAY)
                     
                    ],
                  ),
                
                ),
                ]
              ),

              SizedBox(height: h * 0.02),

              /// PERSONAL
              _sectionCard("Personal Details", [
                _row("DOB", currentMember.dob),
                _row("Age", currentMember.age),
                _row("Blood Group", currentMember.bloodGroup),
              ]),

              SizedBox(height: h * 0.02),

              /// CONTACT
              _sectionCard("Contact", [
                _row("Phone", currentMember.contactNo),
                _row("WhatsApp", currentMember.whatsappNo),
                _row("Email", currentMember.email),
              ]),

              SizedBox(height: h * 0.02),

              /// ADDRESS
              _sectionCard("Address", [
                _row("House", currentMember.address?.houseName),
                _row("Place", currentMember.address?.place),
                _row("Post Office", currentMember.address?.postOffice),
                _row("Pincode", currentMember.address?.pinCode),
                _row("District", currentMember.district),
                _row("Unit", currentMember.unit),
                _row("Area", currentMember.area),

              ]),
               SizedBox(height: h * 0.02),
              _sectionCard("Office Address", [
                _row("Company Name", currentMember.officeAddress?.companyName),
                _row("Place", currentMember.officeAddress?.officePlace),
                _row("Post Office", currentMember.officeAddress?.officePostOffice),
                _row("Pincode", currentMember.officeAddress?.officePinCode),      

              ]),

               SizedBox(height: h * 0.02),
              _sectionCard("Parent Details", [
                _row("Father Name", currentMember.fathername),
                _row("Mother Name", currentMember.mothername),
                _row("Mob", currentMember.fatherMob),
                _row("Email", currentMember.parentEmail),      

              ]),

              SizedBox(height: h * 0.02),

              /// LICENSE
              _sectionCard("License", [
                _row("Category", currentMember.licenceCategory),
                _row("License No", currentMember.licenceNo),
                _row("Expiry", currentMember.licenceExpiry),
              ]),
                SizedBox(height: h * 0.02),

              _sectionCard("Other Details", [
                _row("WelfareNo", currentMember.welfareNo),
                _row("License No", currentMember.qualification),
              ]),
             Consumer<MembershipreniewProvider>(
  builder: (context, provider, child) {

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.membershipreniew.isEmpty) {
      return const Text("No Renewal Data Found");
    }

    /// ✅ FILTER LATEST PER MEMBER
    Map<String, dynamic> latestMap = {};

    for (var item in provider.membershipreniew) {
      final key = item.memberId ?? "";

      if (!latestMap.containsKey(key)) {
        latestMap[key] = item;
      } else {
        final existing = latestMap[key];

        final existingDate =
            DateTime.tryParse(existing.renewalDate ?? "") ?? DateTime(2000);

        final newDate =
            DateTime.tryParse(item.renewalDate ?? "") ?? DateTime(2000);

        if (newDate.isAfter(existingDate)) {
          latestMap[key] = item;
        }
      }
    }

    final latestList = latestMap.values.toList();

    return Column(
      children: latestList
          .map((e) => buildRenewalCard(e))
          .toList(),
    );
  },
)
            ],
          ),
        ),
      ),
    );
  }

  /// COMMON UI

Widget _sectionCard(String title, List<Widget> children) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(w * 0.04), // 15 → responsive
    ),
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(w * 0.03), // 12 → responsive
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: w * 0.035, // responsive font
            ),
          ),
        ),

        Divider(
          height: h * 0.002, // 1 → responsive
        ),

        ...children,
      ],
    ),
  );
}

Widget _row(String title, String? value) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: w * 0.04, // 16 → responsive
      vertical: h * 0.012,  // 10 → responsive
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: w * 0.032, // responsive font
          ),
        ),
        Flexible(
          child: Text(
            value ?? "-",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: w * 0.034, // slightly bigger for value
            ),
          ),
        ),
      ],
    ),
  );
}
//   bool isActive(String? renewalDate) {
//   if (renewalDate == null || renewalDate.isEmpty) return false;

//   try {
//     final expiry = DateTime.parse(renewalDate);
//     return expiry.isAfter(DateTime.now());
//   } catch (e) {
//     return false;
//   }
// }

Widget buildActiveCard(MembersshipreniewModal item) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  final active = isActive(item.renewalDate);

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: w * 0.025, // 10
      vertical: h * 0.005,   // 4
    ),
    decoration: BoxDecoration(
      color: active ? Colors.green.shade100 : Colors.red.shade100,
      borderRadius: BorderRadius.circular(w * 0.05), // 20
    ),
    child: Text(
      active ? "Active" : "Expired",
      style: TextStyle(
        color: active ? Colors.green : Colors.red,
        fontSize: w * 0.03, // 12
      ),
    ),
  );
}
Widget buildRenewalCard(MembersshipreniewModal item) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  final active = isActive(item.renewalDate);

  return Container(
    margin: EdgeInsets.symmetric(
      vertical: h * 0.01, // 8
    ),
    padding: EdgeInsets.all(w * 0.035), // 14
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(w * 0.035), // 14
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: w * 0.015, // 6
          offset: Offset(0, h * 0.004), // 3
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 TOP ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Member ID: ${item.memberId}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: w * 0.035, // responsive
              ),
            ),

            /// STATUS BADGE
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.025, // 10
                vertical: h * 0.005,   // 4
              ),
              decoration: BoxDecoration(
                color: active
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(w * 0.05), // 20
              ),
              child: Text(
                active ? "Active" : "Expired",
                style: TextStyle(
                  color: active ? Colors.green : Colors.red,
                  fontSize: w * 0.03, // 12
                ),
              ),
            )
          ],
        ),

        SizedBox(height: h * 0.012), // 10

        /// 🔹 DETAILS
        _renewRow("Renewal Date", item.renewalDate),
        _renewRow("Payment Date", item.paymentDate),
        _renewRow("Amount", "₹${item.amount}"),
        _renewRow("Payment Mode", item.paymentMode),
        _renewRow("Remarks", item.remarks),
      ],
    ),
  );
}
void openEditDialog(BuildContext context, MembersModal member) {

  final fullName = TextEditingController(text: member.fullName);
  final phone = TextEditingController(text: member.contactNo);
  final whatsapp = TextEditingController(text: member.whatsappNo);
  final email = TextEditingController(text: member.email);
  final rolr = TextEditingController(text: member.role);

  final district = TextEditingController(text: member.district);
  final unit = TextEditingController(text: member.unit);
  final area = TextEditingController(text: member.area);

  final dob = TextEditingController(text: member.dob);
  final age = TextEditingController(text: member.age);
  final blood = TextEditingController(text: member.bloodGroup);

  final licenceNo = TextEditingController(text: member.licenceNo);
  final licenceCategory = TextEditingController(text: member.licenceCategory);
   final licenceExpiry = TextEditingController(text: member.licenceExpiry);

  final house = TextEditingController(text: member.address?.houseName);
  final place = TextEditingController(text: member.address?.place);
  final Apincode = TextEditingController(text: member.address?.pinCode);
  final Apostoffice = TextEditingController(text: member.address?.postOffice);

   final companyname = TextEditingController(text: member.officeAddress?.companyName);
  final Oplace = TextEditingController(text: member.officeAddress?.officePlace);
  final Opincode = TextEditingController(text: member.officeAddress?.officePinCode);
  final Opostoffice = TextEditingController(text: member.officeAddress?.officePostOffice);
  final welcareno = TextEditingController(text: member.welfareNo);
  final qualification = TextEditingController(text: member.qualification);
  final fathername =TextEditingController(text: member.fathername);
    final mothername =TextEditingController(text: member.mothername);
    final fatherMob =TextEditingController(text: member.fatherMob);
     final parentEmail =TextEditingController(text: member.parentEmail);



  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;


  showDialog(

    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.accentLight,
        title:  Text("Edit Profile",style: getFonts(h*0.03, AppColors.accentForegroundLight),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("Personal Details",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),
                _buildField("Full Name", fullName),
                _buildField("DOB", dob),
                _buildField("Age", age),
                _buildField("Blood Group", blood),
                 _buildField("Rolr", rolr),
                   Text("Contact Details",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),

                _buildField("Phone", phone),
                _buildField("WhatsApp", whatsapp),
                _buildField("Email", email),
                
                  Text("Personal Address",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),
                _buildField("HouseName", house),
                _buildField("Place", place),
                _buildField("Post Office", Apostoffice),
                _buildField("Pincode", Apincode),
                _buildField("District", district),
                _buildField("Unit", unit),
                _buildField("Area", area),
                Text("Parent Details",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),
                  _buildField("Father Name",fathername ),
                _buildField("Mother Name", mothername),
                _buildField("Mob", fatherMob),
                _buildField("Email", parentEmail),

                Text("Offfice Address",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),
                  _buildField("CompanyName", companyname),
                _buildField("Place", Oplace),
                _buildField("Post Offfice", Opostoffice),
                _buildField("PinCode", Opincode),
                Text("Licence",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),

                _buildField("Licence No", licenceNo),
                _buildField("Licence Category", licenceCategory),
                _buildField("Licence Expiry", licenceExpiry),

                Text("Other Details",style: getFonts(h*0.02, Colors.black),),
                 SizedBox(height: h*0.01,),
                _buildField("Welfare No", welcareno),
                _buildField("Quaification", qualification),
              ],
            ),
          ),
        ),

        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          Consumer<MemberProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: provider.isLoading
                    ? null
                    : () async {

                        final updated = MembersModal(
                          id: member.id,
                          membershipId: member.membershipId,

                          fullName: fullName.text,
                          contactNo: phone.text,
                          whatsappNo: whatsapp.text,
                          email: email.text,

                          district: district.text,
                          unit: unit.text,
                          area: area.text,

                          dob: dob.text,
                          age: age.text,
                          bloodGroup: blood.text,

                          licenceNo: licenceNo.text,
                          licenceCategory: licenceCategory.text,

                          /// KEEP OLD VALUES
                          role: member.role,
                          welfareNo: member.welfareNo,
                          licenceExpiry: member.licenceExpiry,

                          address: AddressModel(
                            houseName: house.text,
                            place: place.text,
                            postOffice:
                                member.address?.postOffice,
                            pinCode:
                                member.address?.pinCode,
                          ),

                          officeAddress: OfficeAddressModel(
    companyName: companyname.text,
    officePlace: Oplace.text,
    officePostOffice: Opostoffice.text,
    officePinCode: Opincode.text,
  ),
                        );

                        await provider.updateMember(updated);

                        Fluttertoast.showToast(
                          msg: "Profile Updated Successfully",
                          backgroundColor: Colors.green,
                        );

                        Navigator.pop(context);
                      },
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : Container(
                      width: w*0.2,
                      height: w*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w*0.02),
                        gradient: AppColors.gradientPrimary,
                      ),
                      child: Center(child:  Text("Update",style: getFonts(w*0.032, AppColors.accentLight),))),
                    
              );
            },
          )
        ],
      );
    },
  );
}
Widget _buildField(String label, TextEditingController c) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        isDense: true,
      ),
    ),
  );
}

Widget _renewRow(String title, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.grey)),
        Text(value ?? "-",
            style:
                const TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
}