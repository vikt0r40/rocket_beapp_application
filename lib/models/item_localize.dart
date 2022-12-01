class ItemLocalized {
  String language = "";
  String localizedString = "";

  ItemLocalized({required this.language, required this.localizedString});

  ItemLocalized.fromJson(Map<dynamic, dynamic> json) {
    language = json["language"] ?? "";
    localizedString = json["localizedString"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["language"] = language;
    data["localizedString"] = localizedString;
    return data;
  }
}
