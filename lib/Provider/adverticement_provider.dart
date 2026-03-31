import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lensfed/Modals/adverticement_modal.dart';
import 'package:lensfed/Services/api_services.dart';

class AdsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AdModel> _ads = [];
  List<AdModel> get ads => _ads;

  String? _message;
  String? get message => _message;

  /// ================= FETCH =================
  
  Future<void> fetchAds({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getFilteredAds(
        status: status,
        fromDate: fromDate,
        toDate: toDate,
      );

      _ads = response.map<AdModel>((e) {
        return AdModel.fromJson(e);
      }).toList();
    } catch (e) {
      _message = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

}