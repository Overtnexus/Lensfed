class MembersModal {
  final String? id;
  final String? membershipId;
  final String? fullName;

  final AddressModel? address;
  final OfficeAddressModel? officeAddress;

  final String? contactNo;
  final String? whatsappNo;
  final String? email;

  final String? qualification;
  final String? dob;
  final String? age;
  final String? bloodGroup;
  final String? district;
  final String? area;
  final String? unit;

  final String? licenceCategory;
  final String? licenceNo;
  final String? licenceExpiry;
  final String? welfareNo;
  final String? role;
   final String? fathername;
  final String? mothername;
  final String? fatherMob;
  final String? parentEmail;

  MembersModal({
    this.id,
    this.membershipId,
    this.fullName,
    this.address,
    this.officeAddress,
    this.contactNo,
    this.whatsappNo,
    this.email,
    this.qualification,
    this.dob,
    this.age,
    this.bloodGroup,
    this.district,
    this.area,
    this.unit,
    this.licenceCategory,
    this.licenceNo,
    this.licenceExpiry,
    this.welfareNo,
    this.role,
    this.fathername,
    this.mothername,
    this.fatherMob,
    this.parentEmail
  });

  factory MembersModal.fromJson(Map<String, dynamic> json) {
    return MembersModal(
      id: json['id']?.toString(),
      membershipId: json['membershipId']?.toString(),
      fullName: json['fullName']?.toString(),

      address: AddressModel.fromJson(json['address']),
      officeAddress: OfficeAddressModel.fromJson(json['officeAddress']),

      contactNo: json['contactNo']?.toString(),
      whatsappNo: json['whatsappNo']?.toString(),
      email: json['email']?.toString(),
      qualification: json['qualification']?.toString(),
      dob: json['dob']?.toString(),
      age: json['age']?.toString(),
      bloodGroup: json['bloodGroup']?.toString(),
      district: json['district']?.toString(),
      area: json['area']?.toString(),
      unit: json['unit']?.toString(),
      licenceCategory: json['licenceCategory']?.toString(),
      licenceNo: json['licenceNo']?.toString(),
      licenceExpiry: json['licenceExpiry']?.toString(),
      welfareNo: json['welfareNo']?.toString(),
      role: json['role']?.toString(),
      fathername: json['fathername']?.toString(),
      mothername: json['mothername']?.toString(),
      fatherMob: json['fatherMob']?.toString(),
      parentEmail: json['parentEmail']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "membershipId": membershipId,
      "fullName": fullName,
      "address": address?.toJson(),
      "officeAddress": officeAddress?.toJson(),
      "contactNo": contactNo,
      "whatsappNo": whatsappNo,
      "email": email,
      "qualification": qualification,
      "dob": dob,
      "age": age,
      "bloodGroup": bloodGroup,
      "district": district,
      "area": area,
      "unit": unit,
      "licenceCategory": licenceCategory,
      "licenceNo": licenceNo,
      "licenceExpiry": licenceExpiry,
      "welfareNo": welfareNo,
      "role": role,
        "fathername": fathername ?? "",
      "mothername": mothername ?? "",
      "fatherMob": fatherMob ?? "",
      "parentEmail": parentEmail ?? "",
    };
  }
}

class AddressModel {
  final String? houseName;
  final String? place;
  final String? postOffice;
  final String? pinCode;

  AddressModel({
    this.houseName,
    this.place,
    this.postOffice,
    this.pinCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AddressModel();

    return AddressModel(
      houseName: json['houseName']?.toString(),
      place: json['place']?.toString(),
      postOffice: json['postOffice']?.toString(),
      pinCode: json['pinCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "houseName": houseName,
      "place": place,
      "postOffice": postOffice,
      "pinCode": pinCode,
    };
  }
}

class OfficeAddressModel {
  final String? companyName;
  final String? officePlace;
  final String? officePostOffice;
  final String? officePinCode;

  OfficeAddressModel({
    this.companyName,
    this.officePlace,
    this.officePostOffice,
    this.officePinCode,
  });

  factory OfficeAddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OfficeAddressModel();

    return OfficeAddressModel(
      companyName: json['companyName']?.toString(),
      officePlace: json['officePlace']?.toString(),
      officePostOffice: json['officePostOffice']?.toString(),
      officePinCode: json['officePinCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "companyName": companyName,
      "officePlace": officePlace,
      "officePostOffice": officePostOffice,
      "officePinCode": officePinCode,
    };
  }
}