import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lensfed/utilities/fonts.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() =>
      _MembershipRenewalScreenState();
}

class _MembershipRenewalScreenState
    extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _paymentdatecontroller = TextEditingController();
  final TextEditingController _Amountcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _paymentmethodcontroller = TextEditingController();
  final TextEditingController _paymentstatuscontroller = TextEditingController();
  final TextEditingController _remarkscontroller = TextEditingController();
  final TextEditingController _createdbycontroller = TextEditingController();

  String? ReciPayMode;
  String? paymentstatus;

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
        "PAYMENT INCOME",
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
        horizontal:
            isTablet ? screenWidth * 0.2 : screenWidth * 0.05,
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
                "Payment",
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.008),

              Text(
                "Fill in the details below to add your Payments",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.035,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              buildTextField(context, "Payment Date",
                  _paymentdatecontroller),

              DropdownButtonFormField<String>(
                decoration: inputDecoration(
                    context, "Receipt/Payment"),
                value: ReciPayMode,
                items: const [
                  DropdownMenuItem(
                      value: "Receipt",
                      child: Text("Receipt")),
                  DropdownMenuItem(
                      value: "Payment",
                      child: Text("Payment")),
                ],
                onChanged: (value) {
                  setState(() {
                    ReciPayMode = value;
                  });
                },
                validator: (value) =>
                    value == null
                        ? "Select Receipt/Payment"
                        : null,
              ),

              SizedBox(height: screenHeight * 0.02),

              buildTextField(context, "Amount",
                  _Amountcontroller,
                  keyboard: TextInputType.number),

              buildTextField(
                  context, "Name", _namecontroller),

              buildTextField(context, "Payment Method",
                  _paymentmethodcontroller),

              DropdownButtonFormField<String>(
                decoration:
                    inputDecoration(context, "Payment Status"),
                value: paymentstatus,
                items: const [
                  DropdownMenuItem(
                      value: "Pending",
                      child: Text("Pending")),
                  DropdownMenuItem(
                      value: "Processed",
                      child: Text("Processed")),
                ],
                onChanged: (value) {
                  setState(() {
                    paymentstatus = value;
                  });
                },
                validator: (value) =>
                    value == null
                        ? "Select Payment Status"
                        : null,
              ),
              SizedBox(height: screenHeight * 0.02),
              buildTextField(
                  context, "Remarks", _remarkscontroller),

              SizedBox(height: screenHeight * 0.01),

              buildTextField(context, "Created By",
                  _createdbycontroller),

              SizedBox(height: screenHeight * 0.03),

              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              screenWidth * 0.04),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      try{
                        await FirebaseFirestore.instance.collection("Payments").add({
                          "payment_date" :_paymentdatecontroller.text.trim(),
                          "Reci/Pay" : ReciPayMode,
                          "amount":_Amountcontroller.text.trim(),
                          "name" : _namecontroller.text.trim(),
                          "payment_method" :_paymentmethodcontroller.text.trim(),
                          "payment_status" :paymentstatus,
                          "remarks": _remarkscontroller.text.trim(),
                          "created_by":_createdbycontroller,
                          "created_at":Timestamp.now(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added Successfully"))
                        );
                        _paymentdatecontroller.clear();
                        _Amountcontroller.clear();
                        _namecontroller.clear();
                        _paymentmethodcontroller.clear();
                        _remarkscontroller.clear();
                        _createdbycontroller.clear();
                        setState(() {
                          ReciPayMode=null;
                          paymentstatus=null;
                        });
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error : $e"))
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
                      borderRadius:
                          BorderRadius.circular(
                              screenWidth * 0.04),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.04,
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w600,
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