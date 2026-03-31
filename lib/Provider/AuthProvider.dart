import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lensfed/Provider/membershipReniew_provider.dart';
import 'package:lensfed/Views/AuthScreens/Login.dart';
import 'package:lensfed/constance/api_constance.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  String? _membershipId;
  String? get membershipId => _membershipId;
  String? get role => _user?["role"];

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// ================= REGISTER =================
 Future<bool> register({
  required String memberId,
  required String fullName,
  required String email,
  required String password,
}) async {

  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.registerapi),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "memberId": memberId,
        "fullName": fullName,
        "email": email,
        "password": password,
      }),
    );

    print("Register Response: ${response.body}");

    final data = jsonDecode(response.body);

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200 && data["success"] == true) {

      return true;

    } else {

      _errorMessage = data["message"] ?? "Registration failed";
      return false;

    }

  } catch (e) {

    _isLoading = false;
    _errorMessage = e.toString();
    notifyListeners();

    print("Register Error: $e");

    return false;

  }

}

  /// ================= LOGIN =================
  Future<bool> login(String memberId, String password) async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.loginapi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "memberId": memberId,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      _isLoading = false;
      notifyListeners();

    if (response.statusCode == 200 && data["success"] == true) {

  _user = data["user"];
  _membershipId = data["user"]["memberId"];

  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool("isLoggedIn", true);
  await prefs.setString("memberId", _membershipId!);
  await prefs.setString("fullName", _user?["fullName"] ?? "");
  await prefs.setString("email", _user?["email"] ?? "");
  await prefs.setString("role", _user?["role"] ?? "");

  notifyListeners();
  return true;
} else {
        _errorMessage = data["message"] ?? "Login failed";
        return false;
      }

    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUserFromPrefs() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  if (isLoggedIn) {

    _membershipId = prefs.getString("memberId");

    _user = {
      "fullName": prefs.getString("fullName"),
      "email": prefs.getString("email"),
      "role": prefs.getString("role"),
      "memberId": prefs.getString("memberId"),
    };

    notifyListeners();
  }
}

Future<bool> updatePassword({
  required String memberId,
  required String password,
}) async {
  try {
    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updatepassword),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "memberId": memberId,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200 && data["success"] == true) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

Future<bool> verifyOtp({
  required String memberId,
  required String otp,
}) async {

  final response = await http.post(
    Uri.parse(ApiConstants.baseUrl + ApiConstants.verifyOTP),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "memberId": memberId,
      "otp": otp,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> sendOtp({
  required String memberId,
  required String email,
}) async {
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTP),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "memberId": memberId,
        "email": email,
      }),
    );

    print("OTP Response: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      print("OTP Error: ${response.body}");
      return false;
    }
  } catch (e) {
    print("OTP Exception: $e");
    return false;
  }
}

//////////////forgot///////////////////
Future<bool> verifyOtp_forgot({
  required String memberId,
  required String otp,
}) async {

  final response = await http.post(
    Uri.parse(ApiConstants.baseUrl + ApiConstants.verifyOTPforgot),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "memberId": memberId,
      "otp": otp,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> sendOtp_forgot({
  required String memberId,
  required String email,
}) async {
  try {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTPforgot),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "memberId": memberId,
        "email": email,
      }),
    );

    print("OTP Response: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      print("OTP Error: ${response.body}");
      return false;
    }
  } catch (e) {
    print("OTP Exception: $e");
    return false;
  }
}
  /// ================= LOGOUT =================
  void logout() {
    _user = null;
    _membershipId = null;
    notifyListeners();
  }

  Future<void> logout2() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.clear();

  _user = null;
  _membershipId = null;

  notifyListeners();
}


 void logout3(BuildContext context) {
    _user = null;

    /// stop membership checking
    Provider.of<MembershipreniewProvider>(context, listen: false)
        .stopChecking();

Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));


    notifyListeners();
  }

  /// ================= CHECK LOGIN =================
  bool get isLoggedIn => _user != null;
}