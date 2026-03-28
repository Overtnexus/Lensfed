
import 'package:flutter/material.dart';
import 'package:lensfed/Modals/meetings_modal.dart';
import 'package:lensfed/Services/api_services.dart';


class MeetingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MeetingModel> _meeting = [];
  List<MeetingModel> get meeting => _meeting;

  String? _message;
  String? get message => _message;

  MeetingModel? _selectedMeeting;
MeetingModel? get selectedMeeting => _selectedMeeting;


  Future<void> fetchMeeting() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getMeeting();
      _meeting = response.map((e) => MeetingModel.fromJson(e)).toList();
    } catch (e) {
      _message = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
  void setSelectedMeeting(MeetingModel meeting) {
  _selectedMeeting = meeting;
  notifyListeners();
}
}