class WooUserModel {
  bool success = false;
  int statusCode = 0;
  String code = "";
  String message = "";
  Data data = Data();

  WooUserModel();

  WooUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? "";
    statusCode = json['statusCode'] ?? 0;
    code = json['code'] ?? "";
    message = json['message'] ?? "";
    if (json['data'] != null) {
      data = json['data'].length > 0 ? Data.fromJson(json['data']) : Data();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['success'] = success;
    data['statusCode'] = statusCode;
    data['code'] = code;
    data['message'] = message;
    data['data'] = this.data.toJson();

    return data;
  }
}

class Data {
  String token = "";
  int id = 0;
  String email = "";
  String nicename = "";
  String firstName = "";
  String lastName = "";
  String displayName = "";

  Data();

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'] ?? "";
    id = json['id'] ?? 0;
    email = json['email'] ?? "";
    nicename = json['nicename'] ?? "";
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    displayName = json['displayName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['token'] = token;
    data['id'] = id;
    data['email'] = email;
    data['nicename'] = nicename;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['displayName'] = displayName;

    return data;
  }

  getDisplayName() {
    return firstName + " " + lastName;
  }
}
