

import 'dart:convert';

ScanQrService scanQrServiceFromJson(String str) => ScanQrService.fromJson(json.decode(str));

String scanQrServiceToJson(ScanQrService data) => json.encode(data.toJson());

class ScanQrService {
  String code;
  bool status;
  String message;
  List<Datum> data;

  ScanQrService({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ScanQrService.fromJson(Map<String, dynamic> json) => ScanQrService(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String registrationId;
  String firstName;
  String middleName;
  String lastName;
  String serviceId;

  Datum({
    required this.registrationId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.serviceId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    registrationId: json["registration_id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    serviceId: json["service_id"],
  );

  Map<String, dynamic> toJson() => {
    "registration_id": registrationId,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "service_id": serviceId,
  };
}
