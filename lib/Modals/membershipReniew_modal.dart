class MembersshipreniewModal {
  final String? id;
  final String? renewalDate;
  final String? paymentDate;
  final String? memberId;
  final String? amount;
  final String? remarks;
  final String? paymentMode;
  final String? createdBY;

  MembersshipreniewModal({
    this.id,
    this.renewalDate,
    this.paymentDate,
    this.amount,
    this.memberId,
    this.remarks,
    this.paymentMode,
    this.createdBY
  });

  factory MembersshipreniewModal.fromJson(Map<String, dynamic> json) {
  return MembersshipreniewModal(
    id: json['id']?.toString(),

    renewalDate: json['renewaldate']?.toString() ?? "",
    paymentDate: json['paymentdate']?.toString() ?? "",

    amount: json['amount']?.toString() ?? "",
    memberId: json['memberId']?.toString() ?? "",
    remarks: json['remarks']?.toString() ?? "",
    paymentMode: json['paymentMode']?.toString() ?? "",
    createdBY: json["createdBY"]?.toString() ?? "",
  );
}

 Map<String, dynamic> toJson() {
  return {
    "id": id,
    "renewaldate": renewalDate ?? "",
    "paymentdate": paymentDate ?? "",
    "amount": amount ?? "",
    "memberId": memberId ?? "",
    "remarks": remarks ?? "",
    "paymentMode": paymentMode ?? "",
    "createdBY": createdBY ?? "",
  };
}
}