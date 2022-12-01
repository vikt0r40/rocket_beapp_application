import 'dart:ui';

class Splash {
  String imageUrl = "";
  List<int> splashColor = [255, 255, 255];

  Splash({required this.imageUrl, required List<int> colors});

  Splash.fromJson(Map<dynamic, dynamic> json) {
    imageUrl = json["imageUrl"];
    splashColor = json['splashColor'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["imageUrl"] = imageUrl;
    data['splashColor'] = splashColor.cast<int>();
    return data;
  }

  Color getSplashColor() {
    return Color.fromRGBO(splashColor[0], splashColor[1], splashColor[2], 1);
  }
}
