class BeUser {
  String uid = "";
  String displayName = "";
  String email = "";

  BeUser({required this.uid, required this.displayName, required this.email});

  BeUser.fromJson(Map<dynamic, dynamic> json) {
    uid = json["uid"] ?? "";
    email = json['email'] ?? "";
    displayName = json['display_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["uid"] = uid;
    data["email"] = email;
    data["display_name"] = displayName;
    return data;
  }
}
