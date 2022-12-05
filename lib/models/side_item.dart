import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/items/woo_commerce/woo_globals.dart';
import 'item_localize.dart';

enum ItemType {
  text,
  link,
  googleMaps,
  feedback,
  rateUs,
  home,
  aboutUs,
  gallery,
  chat,
  qrCode,
  videos,
  wooProducts,
  social,
  sideScreen,
  phone,
  wordpress,
  radioStreams,
  youTubeVideos,
  vimeoVideos,
  appointments,
  languages,
  signOut,
  profile,
}

class SideItem {
  String uid = "";
  String title = "";
  String text = "";
  String latitude = "";
  String longitude = "";
  String link = "";
  String address = "";
  String customJS = "";
  String categoryID = "";
  String tagID = "";
  String fontFamily = "FontAwesomeSolid";
  int iconCode = 0;
  ItemType type = ItemType.text;
  bool enableLogoAndTitle = false;
  bool enableFooter = false;
  List<ItemLocalized> localizations = [];

  SideItem({required this.title});

  SideItem.fromJson(Map<dynamic, dynamic> json) {
    if (json["localizations"] != null) {
      json['localizations'].forEach((v) {
        localizations.add(ItemLocalized.fromJson(v));
      });
    }
    uid = json['uid'] ?? "";
    title = json["title"] ?? "";
    text = json["text"] ?? "";
    latitude = json["latitude"] ?? "";
    longitude = json["longitude"] ?? "";
    link = json["link"] ?? "";
    address = json["address"] ?? "";
    customJS = json["customJS"] ?? "";
    type = ItemType.values[json["type"]];
    iconCode = json["iconCode"] ?? "";
    fontFamily = json['fontFamily'] ?? "";
    categoryID = json['categoryID'] ?? "";
    tagID = json['tagID'] ?? "";
    enableLogoAndTitle = json['enableLogoAndTitle'] ?? false;
    enableFooter = json['enableFooter'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["localizations"] = localizations.map((v) => v.toJson()).toList();
    data['uid'] = uid;
    data['title'] = title;
    data['text'] = text;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['link'] = link;
    data['type'] = type.index;
    data['address'] = address;
    data['customJS'] = customJS;
    data['iconCode'] = iconCode;
    data['fontFamily'] = fontFamily;
    data['enableLogoAndTitle'] = enableLogoAndTitle;
    data['enableFooter'] = enableFooter;
    data['categoryID'] = categoryID;
    data['tagID'] = tagID;
    return data;
  }

  dynamic getSideItemIcon() {
    if (fontFamily.contains("Regular")) {
      return IconDataRegular(iconCode);
    } else if (fontFamily.contains("Brands")) {
      return IconDataBrands(iconCode);
    } else {
      return IconDataSolid(iconCode);
    }
  }

  String getLocalizedTitle() {
    for (ItemLocalized itemLocalized in localizations) {
      if (itemLocalized.language == mainLocalization.name) {
        return itemLocalized.localizedString;
      }
    }
    return title;
  }
}
