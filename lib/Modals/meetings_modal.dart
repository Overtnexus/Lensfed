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
  });

  /// FROM JSON
  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'],
      meetingDate: json['meetingDate']?.toString() ,
      meetingTime: json['meetingTime']?.toString(),
      meetingLocation: json['meetingLocation']?.toString(),
      addressLine1: json['addressLine1']?.toString(),
      addressLine2: json['addressLine2']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      postalCode: json['postalCode']?.toString(),
      country: json['country']?.toString(),
      meetingName: json['meetingName']?.toString(),
      meetingAttendees: json['meetingAttendees']?.toString(),
      meetingType: json['meetingType']?.toString(),
      meetingStatus: json['meetingStatus']?.toString(),
      meetingAgenda: json['meetingAgenda']?.toString(),
      meetingReminder: json['meetingReminder']?.toString(),
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meetingDate': meetingDate,
      'meetingTime': meetingTime,
      'meetingLocation': meetingLocation,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'meetingName': meetingName,
      'meetingAttendees': meetingAttendees,
      'meetingType': meetingType,
      'meetingStatus': meetingStatus,
      'meetingAgenda': meetingAgenda,
      'meetingReminder': meetingReminder,
    };
  }}