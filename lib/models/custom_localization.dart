import 'localization.dart';

class CustomLocalization {
  String name = "";
  Localization localization = Localization();
  bool isRTL = false;

  CustomLocalization({required this.name, required this.localization});

  CustomLocalization.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] ?? "";
    localization = Localization.fromJson(json['localization']);
    isRTL = json['isRTL'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["localization"] = localization.toJson();
    data['isRTL'] = isRTL;
    return data;
  }
}
