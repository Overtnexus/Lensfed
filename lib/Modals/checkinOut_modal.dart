class CheckinoutModal {
  final String? id;
  final String meetingSchedule;
  final String checkinDate;
  final String checkinTime;
  final String member;
  final String notes;
  final String createdBY;

  CheckinoutModal({
    this.id,
   required this.meetingSchedule,
   required this.checkinDate,
   required this.checkinTime,
   required this.member,
   required this.notes,
   required this.createdBY
  });

  factory CheckinoutModal.fromJson(Map<String, dynamic> json) {
    return CheckinoutModal(
      id: json['id'],
      meetingSchedule: json['meeting_schedule'],
      checkinDate: json['checkin_date'],
      checkinTime: json['checkin_time'],
      member: json['member'],
      notes: json['notes'],
      createdBY: json['createdBY'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meeting_schedule': meetingSchedule,
      'checkin_date': checkinDate,
      'checkin_time': checkinTime,
      'member': member,
      'notes': notes,
      'createdBY':createdBY,
    };
  }
}