
import 'package:flutter/material.dart';
import 'package:lensfed/Modals/member_modal.dart';
import 'package:lensfed/Services/api_services.dart';


class MemberProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MembersModal> _members = [];
  List<MembersModal> get members => _members;

  String? _message;
  String? get message => _message;

 Future<void> addMembers(MembersModal members) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response =
        await _apiService.AddMember(members.toJson());

    _message = response["message"] ?? "Success";

    await fetchMembers();
  } catch (e) {
    _message = "Error: ${e.toString()}";
  }

  _isLoading = false;
  notifyListeners();
}

  // FETCH ALL UNITS
  Future<void> fetchMembers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getMember();
      _members = response.map((e) => MembersModal.fromJson(e)).toList();
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // UPDATE
  Future<void> updateMember(MembersModal member) async {
    if (member.id == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.updateMember(member.id!, member.toJson());
      _message = response["message"];
      await fetchMembers();
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // DELETE
  Future<void> deleteMember(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.deleteMember(id);
      _message = response["message"];
      await fetchMembers();
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  MembersModal? getLoggedMember(String? membershipId) {
  if (membershipId == null) return null;

  try {
    return _members.firstWhere(
      (member) => member.membershipId == membershipId,
    );
  } catch (e) {
    return null;
  }
}
}