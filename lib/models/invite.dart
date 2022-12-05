class Invite {
  String code = "";
  bool isUsed = false;

  Invite();

  Invite.fromJson(Map<dynamic, dynamic> json) {
    code = json["code"] ?? "";
    isUsed = json["isUsed"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    data["isUsed"] = isUsed;
    return data;
  }
}
