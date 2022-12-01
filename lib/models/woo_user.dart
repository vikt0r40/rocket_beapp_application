class WooUser {
  String email = "";
  String firstName = "";
  String lastName = "";
  String password = "";

  WooUser();

  WooUser.fromJson(Map<String, dynamic> json) {
    email = json['email'] ?? "";
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email
    });

    return map;
  }
}
