import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lensfed/constance/api_constance.dart';

class ApiService {
 Future<Map<String, dynamic>> addUnit(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addUnit);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getUnits() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getUnits),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updateUnit(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updateUnit + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deleteUnit(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteUnit + id),
    );

    return jsonDecode(response.body);
  }

  ///PAYMENTS
   Future<Map<String, dynamic>> AddPayment(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addpayments);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getPayments() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getpayments),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updatePayment(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updatepayments + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deletePayment(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deletepayments + id),
    );

    return jsonDecode(response.body);
  }

  /////CheckinOut
     Future<Map<String, dynamic>> AddCheckinOut(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addcheckinout);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getCheckinOut() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getcheckinout),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updateCheckinOut(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updatecheckinout + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deleteCheckinOut(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deletecheckinout + id),
    );

    return jsonDecode(response.body);
  }

  /////MEMBERSHIP RENIEW
  
     Future<Map<String, dynamic>> AddMembershipReniew(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addmembersshipreniew);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getMembershipReniew() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getmembersshipreniew),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updateMembershipReniew(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updatemembersshipreniew + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deleteMembershipReniew(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deletemembersshipreniew + id),
    );

    return jsonDecode(response.body);
  }

  /////MEMBERS
  
       Future<Map<String, dynamic>> AddMember(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addmembers);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getMember() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getmembers),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updateMember(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updatemembers + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deleteMember(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deletemembers + id),
    );

    return jsonDecode(response.body);
  }

  //////MEETINGS
  
  Future<Map<String, dynamic>> AddMeeting(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addmeetings);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getMeeting() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getmeetings),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updateMeeting(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updatemeetings + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deleteMeeting(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deletemeetings + id),
    );

    return jsonDecode(response.body);
  }

  ////notification
    Future<Map<String, dynamic>> AddNotification(Map<String, dynamic> data) async {
  try {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.addNotification);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Server Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("API ERROR: $e");
    rethrow;
  }
}
  //GET
    Future<List<dynamic>> getNotification() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.getNotification),
    );

    return jsonDecode(response.body);
  }

  // UPDATE
  Future<Map<String, dynamic>> updateNotification(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.updateNotification + id),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // DELETE
  Future<Map<String, dynamic>> deleteNotification(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteNotification + id),
    );

    return jsonDecode(response.body);
  }
/////////////////////////ADMIN LOGIN////////////

Future<Map<String, dynamic>> adminLogin(
    String username, String password) async {

  final response = await http.post(
    Uri.parse(ApiConstants.baseUrl+ApiConstants.loginadmin),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "username": username,
      "password": password
    }),
  );

  return jsonDecode(response.body);
}

}