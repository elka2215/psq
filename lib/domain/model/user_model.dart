import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.result,
    required this.data,
    required this.error,
  });

  bool result;
  Data data;
  Error error;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    result: json["result"],
    data: Data.fromJson(json["data"]),
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": data.toJson(),
    "error": error.toJson(),
  };
}

class Data {
  Data({
    this.phone,
    this.name,
    this.code,
  });

  String? phone;
  String? name;
  String? code;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    phone: json["phone"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "name": name,
    "code": code,
  };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error(
  );

  Map<String, dynamic> toJson() => {
  };
}
