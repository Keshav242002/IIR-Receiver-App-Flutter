// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  String code;
  bool status;
  String message;
  Result result;

  ServiceModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "result": result.toJson(),
  };
}

class Result {
  List<Detail> details;

  Result({
    required this.details,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class Detail {
  String serviceId;

  String serviceName;


  Detail({
    required this.serviceId,

    required this.serviceName,

  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    serviceId: json["service_id"],

    serviceName: json["service_name"],

  );

  Map<String, dynamic> toJson() => {
    "service_id": serviceId,

    "service_name": serviceName,


  };
}
