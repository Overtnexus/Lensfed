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
        title: Center(child: Text("PAYMENT INCOME",style: getFonts(18, Colors.white),)),
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
                    "Payment",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Fill in the details below to add your Payments",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  buildTextField("Unit Name", _paymentdatecontroller),
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration("Reciept/Payment"),
                    value: DistrictMode,
                    items: const [
                      DropdownMenuItem(
                          value: "Reciept",
                          child: Text("Reciept")),
                      DropdownMenuItem(
                          value: "Payment",
                          child: Text("Payment")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        DistrictMode = value;
                      });
                    },
                    validator: (value) =>
                        value == null
                            ? "Select Reciept/Payment"
                            : null,
                  ),
                  buildTextField("Amount", _Amountcontroller,
                      keyboard: TextInputType.number),
                   buildTextField("Name", _namecontroller),
                   buildTextField("Payment Method", _paymentmethodcontroller),   
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration("Payment Status"),
                    value: DistrictMode,
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
                        DistrictMode = value;
                      });
                    },
                    validator: (value) =>
                        value == null
                            ? "Select Payment Status"
                            : null,
                  ),
                 buildTextField("Remarks", _remarkscontroller),
                 buildTextField("Created By", _createdbycontroller),
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
                                  "Submitted Successfully"),
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