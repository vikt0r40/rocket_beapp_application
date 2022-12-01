import 'package:be_app_mobile/models/localization.dart';
import 'package:be_app_mobile/models/side_item.dart';
import 'package:be_app_mobile/models/splash.dart';
import 'package:be_app_mobile/models/welcome_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'custom_localization.dart';
import 'onboaring_page.dart';

class AppOptions {
  List<SideItem> sideItems = [];
  List<SideItem> navItems = [];
  List<SideItem> floatingItems = [];
  List<OnboardingPage> onboardingPages = [];
  List<String> imageUrls = [];
  List<CustomLocalization> customLocalizations = [];
  WelcomePopup popup = WelcomePopup(title: "", text: "", imageUrl: "");
  Splash splash = Splash(imageUrl: "", colors: []);
  Localization localization = Localization();

  AppOptions() {
    navItems = getExampleItems();
    floatingItems = getExampleItems();
    sideItems = getExampleItems();
    customLocalizations = <CustomLocalization>[];
  }

  AppOptions.fromJson(Map<dynamic, dynamic> json) {
    if (json["items"] != null) {
      json['items'].forEach((v) {
        sideItems.add(SideItem.fromJson(v));
      });
    }
    if (json["navItems"] != null) {
      json['navItems'].forEach((v) {
        navItems.add(SideItem.fromJson(v));
      });
    }
    if (json["floatingItems"] != null) {
      json['floatingItems'].forEach((v) {
        floatingItems.add(SideItem.fromJson(v));
      });
    }
    if (json["gallery_images"] != null) {
      json['gallery_images'].forEach((v) {
        imageUrls.add(v);
      });
    }
    if (json["onBoardingPages"] != null) {
      json['onBoardingPages'].forEach((v) {
        onboardingPages.add(OnboardingPage.fromJson(v));
      });
    }
    if (json["popup"] != null) {
      popup = WelcomePopup.fromJson(json["popup"]);
    }
    if (json["splash"] != null) {
      splash = Splash.fromJson(json["splash"]);
    }
    if (json["localizations"] != null) {
      localization = Localization.fromJson(json["localizations"]);
    }
    if (json["customLocalizations"] != null) {
      for (var element in json["customLocalizations"]) {
        CustomLocalization item = CustomLocalization.fromJson(element);
        customLocalizations.add(item);
      }
    }
    customLocalizations.insert(0, CustomLocalization(name: "English", localization: localization));
  }

  List<SideItem> getExampleItems() {
    SideItem homeItem = SideItem(title: "Home");
    homeItem.type = ItemType.home;
    homeItem.iconCode = FontAwesomeIcons.house.codePoint;
    homeItem.fontFamily = FontAwesomeIcons.house.fontFamily ?? "";

    //Create chat item
    SideItem chatItem = SideItem(title: "Chat");
    chatItem.type = ItemType.chat;
    chatItem.iconCode = FontAwesomeIcons.comment.codePoint;
    chatItem.fontFamily = FontAwesomeIcons.comment.fontFamily ?? "";

    List<SideItem> exampleItems = [homeItem, chatItem];
    return exampleItems;
  }
}
