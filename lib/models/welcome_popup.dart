class WelcomePopup {
  String title = "";
  String text = "";
  String imageUrl = "";
  bool isEnabled = false;
  bool showAlways = true;

  WelcomePopup({required this.title, required this.text, required this.imageUrl});

  WelcomePopup.fromJson(Map<dynamic, dynamic> json) {
    title = json["title"];
    text = json["text"];
    imageUrl = json["imageUrl"];
    isEnabled = json['isEnabled'];
    showAlways = json['showAlways'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["text"] = text;
    data["imageUrl"] = imageUrl;
    data["isEnabled"] = isEnabled;
    data["showAlways"] = showAlways;
    return data;
  }
}
