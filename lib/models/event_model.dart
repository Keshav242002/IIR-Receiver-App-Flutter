import 'dart:convert';

EventModel eventModelFromJson(String str) => EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  String code;
  bool status;
  String message;
  Result result;

  EventModel({
    required this.code,
    required this.status,
    required this.message,
    required this.result,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
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
  String id;
  String eventName;
  String eventOwnerName;
  String mobile;
  String email;
  String briefDetail;
  String detail;
  String location;
  String registrationCharges;
  String startDate;
  String endDate;

  Detail({
    required this.id,
    required this.eventName,
    required this.eventOwnerName,
    required this.mobile,
    required this.email,
    required this.briefDetail,
    required this.detail,
    required this.location,
    required this.registrationCharges,
    required this.startDate,
    required this.endDate,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    eventName: json["event_name"],
    eventOwnerName: json["event_owner_name"],
    mobile: json["mobile"],
    email: json["email"],
    briefDetail: json["brief_detail"],
    detail: json["detail"],
    location: json["location"],
    registrationCharges: json["registration_charges"],
    startDate:json["start_date"],
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_name": eventName,
    "event_owner_name": eventOwnerName,
    "mobile": mobile,
    "email": email,
    "brief_detail": briefDetail,
    "detail": detail,
    "location": location,
    "registration_charges": registrationCharges,
    "start_date": startDate,
    "end_date": endDate,
  };
}
