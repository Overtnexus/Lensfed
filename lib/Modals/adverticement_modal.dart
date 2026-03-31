class AdModel {
  String? id;
  String? title;
  String? attachmentLink; // ✅ NEW FIELD
  DateTime? startDate;
  DateTime? endDate;

  AdModel({
    this.id,
    this.title,
    this.attachmentLink,
    this.startDate,
    this.endDate,
  });

  /// ================= FROM JSON =================
  factory AdModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return AdModel(
      id: docId ?? json['id'],
      title: json['title'] ?? "",
      attachmentLink: json['attachmentLink'] ?? "", // ✅ UPDATED
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
    );
  }

  /// ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      "title": title ?? "",
      "attachmentLink": attachmentLink ?? "", // ✅ UPDATED
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
    };
  }
}