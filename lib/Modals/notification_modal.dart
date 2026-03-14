import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String? title;
  final String? message;
  final String? role;
  final String? createDateTime;
  final String? sendDateTime;
  final String? attachment;
  final String? createdBY;
  final bool isSent;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.role,
    this.createDateTime,
    this.sendDateTime,
    this.attachment,
    this.createdBY,
    this.isSent = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {

    String? createTime;
    String? sendTime;

    // convert Firestore Timestamp to String
    if (json["createDateTime"] != null) {
      if (json["createDateTime"] is Timestamp) {
        createTime =
            (json["createDateTime"] as Timestamp).toDate().toString();
      } else {
        createTime = json["createDateTime"].toString();
      }
    }

    if (json["sendDateTime"] != null) {
      if (json["sendDateTime"] is Timestamp) {
        sendTime =
            (json["sendDateTime"] as Timestamp).toDate().toString();
      } else {
        sendTime = json["sendDateTime"].toString();
      }
    }

    return NotificationModel(
      id: json["id"],
      title: json["title"],
      message: json["message"],
      role: json["role"],
      createDateTime: createTime,
      sendDateTime: sendTime,
      attachment: json["attachment"],
      createdBY: json["createdBY"],
      isSent: json["isSent"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "message": message,
      "role": role,
      "createDateTime": createDateTime,
      "sendDateTime": sendDateTime,
      "attachment": attachment,
      "createdBY": createdBY,
      "isSent": isSent
    };
  }
}