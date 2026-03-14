
import 'package:flutter/material.dart';
import 'package:lensfed/Modals/checkinOut_modal.dart';
import 'package:lensfed/Services/api_services.dart';


class CheckinOutProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CheckinoutModal> _checkinout = [];
  List<CheckinoutModal> get chechiout => _checkinout;

  String? _message;
  String? get message => _message;

  // ADD UNIT
 Future<void> addCheckinout(CheckinoutModal checkinout) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response =
        await _apiService.AddCheckinOut(checkinout.toJson());

    _message = response["message"] ?? "Success";

    await fetchCheckinout();
  } catch (e) {
    _message = "Error: ${e.toString()}";
  }

  _isLoading = false;
  notifyListeners();
}

  // FETCH ALL UNITS
  Future<void> fetchCheckinout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCheckinOut();
      _checkinout = response.map((e) => CheckinoutModal.fromJson(e)).toList();
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

}