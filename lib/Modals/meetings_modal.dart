class MeetingModel {
  final String? id;

  final String? meetingDate;
  final String? meetingTime;
  final String? meetingLocation;

  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  final String? meetingName;
  final String? meetingAttendees;
  final String? meetingType;
  final String? meetingStatus;
  final String? meetingAgenda;
  final String? meetingReminder;
  final String? meetingEndTime;
  final String? createdBy;

  MeetingModel({
    this.id,
    this.meetingDate,
    this.meetingTime,
    this.meetingLocation,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.meetingName,
    this.meetingAttendees,
    this.meetingType,
    this.meetingStatus,
    this.meetingAgenda,
    this.meetingReminder,
    this.meetingEndTime,
    this.createdBy,
  });

  /// SAFE STRING HELPER
  static String? _getString(dynamic value) {
    if (value == null) return null;
    if (value.toString().toLowerCase() == "null") return null;
    return value.toString();
  }

  /// DATE FORMAT FIX (IMPORTANT 🔥)
  static String? _formatDate(dynamic value) {
    if (value == null) return null;

    try {
      DateTime date = DateTime.parse(value.toString());

      /// Convert to dd-MM-yyyy (your UI format)
      return "${date.day.toString().padLeft(2, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.year}";
    } catch (e) {
      /// If already formatted, return as is
      return value.toString();
    }
  }

  /// FROM JSON
  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    return MeetingModel(
      
      id: _getString(json['id'] ?? json['_id']),

      meetingDate: _formatDate(json['meetingDate']),
      meetingTime: _getString(json['meetingTime']),
      meetingLocation: _getString(json['meetingLocation']),

      addressLine1: _getString(address['addressLine1']),
    addressLine2: _getString(address['addressLine2']),
    city: _getString(address['city']),
    state: _getString(address['state']),
    postalCode: _getString(address['postalCode']),
    country: _getString(address['country']),

      meetingName: _getString(json['meetingName']),
      meetingAttendees: _getString(json['meetingAttendees']),
      meetingType: _getString(json['meetingType']),
      meetingStatus: _getString(json['meetingStatus']),
      meetingAgenda: _getString(json['meetingAgenda']),
      meetingReminder: _getString(json['meetingReminder']),
      meetingEndTime: _getString(json['meetingEndTime']),

      /// handle both cases
      createdBy: _getString(json['createdBy'] ?? json['createdBY']),
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "meetingDate": meetingDate,
      "meetingTime": meetingTime,
      "meetingLocation": meetingLocation,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "city": city,
      "state": state,
      "postalCode": postalCode,
      "country": country,
      "meetingName": meetingName,
      "meetingAttendees": meetingAttendees,
      "meetingType": meetingType,
      "meetingStatus": meetingStatus,
      "meetingAgenda": meetingAgenda,
      "meetingReminder": meetingReminder,
      "meetingEndTime":meetingEndTime,
      "createdBy": createdBy,
    };
  }
}