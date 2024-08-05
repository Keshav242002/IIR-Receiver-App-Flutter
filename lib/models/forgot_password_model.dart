import 'dart:convert';

GeneralModel generalModelFromJson(String str) =>
    GeneralModel.fromJson(json.decode(str));

String generalModelToJson(GeneralModel data) => json.encode(data.toJson());

class GeneralModel {
  GeneralModel({
    required this.code,
    required this.status,
    required this.message,
  });

  int code;
  bool status;
  String message;

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
      };
}
