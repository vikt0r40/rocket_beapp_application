class BeFeedback {
  String uid = "";
  String name = "";
  String email = "";
  String title = "";
  String description = "";

  BeFeedback(
      {required this.name,
      required this.email,
      required this.title,
      required this.description});

  BeFeedback.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"];
    email = json["email"];
    title = json["title"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["email"] = email;
    data["title"] = title;
    data["description"] = description;
    return data;
  }
}
