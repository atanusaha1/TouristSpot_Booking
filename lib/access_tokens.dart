import 'dart:convert';

class AccessTokens {
  static var authToken = '';
}

class LoginResponse {
  dynamic? key;
  List<dynamic>? non_field_errors;
  LoginResponse({this.key, this.non_field_errors});

  factory LoginResponse.fromJson(mapOfBody) {
    return LoginResponse(
      key: mapOfBody['key'],
      non_field_errors: mapOfBody['non_field_errors'],
    );
  }
}

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  dynamic? key;
  List<dynamic>? non_field_errors;
  LoginResponseModel({this.key, this.non_field_errors});

  LoginResponseModel.fromJson(mapOfBody) {
    key:
    mapOfBody['key'];
    non_field_errors:
    mapOfBody['non_field_errors'];
    print(mapOfBody['key']);

    final storage = new FlutterSecureStorage();
    // Write value
    // storage.(key: 'Token', value: mapOfBody['key']); //////////////////////////////////////////////////////////////
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['key'] = key;
    _data['non_field_errors'] = non_field_errors;
    return _data;
  }
}

class FlutterSecureStorage {}

class Data {
  Data({
    required this.username,
    required this.email,
    required this.date,
    required this.id,
    required this.key,
  });

  late final String username;
  late final String email;
  late final String date;
  late final String id;
  late final String key;

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    date = json['date'];
    id = json['id'];
    key = json['key'];
  }
}
