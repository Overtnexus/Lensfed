class CheckinoutModal {
  final String? id;
  final String meetingSchedule;
  final String checkinDate;
  final String checkinTime;
  final String member;
  final String? checkoutTime;
  final String? totalHrs;

  CheckinoutModal({
    this.id,
    required this.meetingSchedule,
    required this.checkinDate,
    required this.checkinTime,
    required this.member,
    this.checkoutTime,
    this.totalHrs,
  });

  /// FROM JSON
  factory CheckinoutModal.fromJson(Map<String, dynamic> json) {
    return CheckinoutModal(
      id: json['id'] ?? json['_id'],
      meetingSchedule: json['meeting_schedule'] ?? "",
      checkinDate: json['checkin_date'] ?? "",
      checkinTime: json['checkin_time'] ?? "",
      member: json['member'] ?? "",
      checkoutTime: json['checkout_time'],
      totalHrs: json['total_hrs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meeting_schedule': meetingSchedule,
      'checkin_date': checkinDate,
      'checkin_time': checkinTime,
      'member': member,
      'checkout_time': checkoutTime,
      'total_hrs': totalHrs,
    };
  }
}