import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lensfed/Modals/membershipReniew_modal.dart';
import 'package:lensfed/Provider/AuthProvider.dart';
import 'package:lensfed/Services/api_services.dart';
import 'package:provider/provider.dart';


class MembershipreniewProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MembersshipreniewModal> _Membershipreniew = [];
  List<MembersshipreniewModal> get membershipreniew => _Membershipreniew;

  String? _message;
  String? get message => _message;

 Future<void> fetchMembersshipreniew(String? memberId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getMembershipReniew();

      final allData = response
          .map((e) => MembersshipreniewModal.fromJson(e))
          .toList();

      /// ✅ ADMIN → ALL DATA
      if (memberId != null && memberId.toLowerCase() == "admin") {
        _Membershipreniew = allData;
      }
      /// ✅ NORMAL USER → ONLY HIS DATA
      else {
        _Membershipreniew = allData
            .where((e) =>
                (e.memberId ?? "").toString() ==
                (memberId ?? "").toString())
            .toList();
      }
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isMembershipExpired(String memberId) async {
  try {
    final res = await _apiService.checkMembership(memberId);

    return res["isExpired"] == true;
  } catch (e) {
    return false;
  }
}

  Timer? _timer;

  /// ✅ START CHECKING (ONLY CALL ONCE AFTER LOGIN)
  void startChecking(BuildContext context) {
    final auth =
        Provider.of<AuthProvider>(context, listen: false);

    final memberId = auth.membershipId;

    if (memberId == null) return;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final res = await _apiService.checkMembership(memberId);

        bool isExpired = res["isExpired"] == true;

        if (isExpired) {
          /// 🔥 AUTO LOGOUT
          Provider.of<AuthProvider>(context, listen: false)
              .logout3(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Membership expired. Please renew."),
              backgroundColor: Colors.red,
            ),
          );

          _timer?.cancel();
        }
      } catch (e) {
        debugPrint("Membership error: $e");
      }
    });
  }

  /// 🛑 STOP TIMER
  void stopChecking() {
    _timer?.cancel();
  }
Future<bool> checkMembershipExpired(String memberId) async {
  try {
    debugPrint("🔍 Checking membership for ID: $memberId");

    /// 📡 API CALL
    final res = await _apiService.checkMembership(memberId);

    debugPrint("✅ API Response: $res");

    /// 🧠 CHECK VALUE
    if (res == null) {
      debugPrint("Response is NULL");
      return false;
    }

    if (!res.containsKey("isExpired")) {
      debugPrint("'isExpired' key missing in response");
      return false;
    }

    bool isExpired = res["isExpired"] == true;

    debugPrint("📊 Membership Expired Status: $isExpired");

    /// OPTIONAL: LOG DATE
    if (res.containsKey("renewaldate")) {
      debugPrint("📅 Renewal Date: ${res["renewaldate"]}");
    }

    return isExpired;

  } catch (e, stackTrace) {
    debugPrint("🔥 ERROR in checkMembershipExpired: $e");
    debugPrint("📌 StackTrace: $stackTrace");

    return false;
  }
}
}