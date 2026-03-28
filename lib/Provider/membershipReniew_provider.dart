import 'package:flutter/material.dart';
import 'package:lensfed/Modals/membershipReniew_modal.dart';
import 'package:lensfed/Services/api_services.dart';


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


}