import 'package:be_app_mobile/models/social.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class General {
  String mainURL = "https://www.cosmotic.space/";
  String shareMsg = "Hey check out this awesome app. You can do so much with it..";
  List<int> headerRGB = [0, 0, 0];
  List<int> headerItemsRGB = [255, 255, 255];
  List<int> headerItemsSelectedRGB = [0, 0, 0];
  List<int> sideMenuRGB = [255, 255, 255];
  List<int> sideMenuItemsRGB = [0, 0, 0];
  List<int> sideMenuHeaderRGB = [0, 0, 0];
  List<int> floatingMenuRGB = [0, 0, 0];
  List<int> floatingIconRGB = [255, 255, 255];
  List<int> topNavigationRGB = [0, 0, 0];
  List<int> topNavigationItemsRGB = [255, 255, 255];
  List<int> statusColorRGB = [255, 255, 255];
  List<int> androidSystemButtonsColor = [0, 0, 0];
  List<int> onBoardingRGB = [0, 0, 0];
  List<int> onBoardingTextRGB = [255, 255, 255];
  bool enableRefreshOnNavigation = false;
  bool enableShare = true;
  bool enableTopNavigation = true;
  bool centerTopTitle = true;
  bool enabledAdmob = false;
  bool blockVPNUsers = false;
  bool enabledAnalytics = true;
  bool enableSideMenu = true;
  bool enableBottomNavigation = true;
  bool enableCustomJavascript = true;
  bool enableNoInternetPopup = true;
  bool enableFloatingButton = true;
  bool enableConstructionMode = false;
  bool enableAuthorization = false;
  bool enableFacebookLogin = false;
  bool enableGoogleLogin = false;
  bool enableCenterTitlesSideScreen = false;
  bool enableEmailLogin = false;
  bool enableSafeArea = false;
  bool enableRTL = false;
  bool enableLandscape = false;
  bool enableScreenSecurity = false;
  bool enableMultiWindow = false;
  bool enableLoadingWebView = true;
  bool enableHorizontalScroll = false;
  bool enableExitApp = false;
  bool enableToastOnJsAlerts = true;
  bool reloadWebViewOnBackground = false;
  String fontName = "Roboto";
  int loadingType = 1;
  int bottomNavigationType = 1;
  List<int> loadingRGB = [0, 0, 0];
  List<int> applicationColor = [255, 255, 255];
  int loadingSize = 30;
  String customJavascriptCode = "";
  String logoUrl =
      "https://firebasestorage.googleapis.com/v0/b/mini-football-manager-7512c.appspot.com/o/images%2Fb0312cf0-ac1b-11ec-81b4-9b5036bc270d?alt=media&token=1e319587-15d2-4f24-b3cf-a2b0e3ddb1d5";
  SlideDirection sideMenuDirection = SlideDirection.LEFT_TO_RIGHT;
  String androidAdMobID = "";
  String iOSAdmobID = "";
  String rateAppleStoreID = "";
  String rateAndroidStoreID = "";
  String serverKey = "";
  bool instantUpdates = true;
  bool pullDownToRefresh = true;
  bool customUserAgent = false;
  String customUserAgentString = "";
  bool enableWebRTC = false;
  bool enablePinchZoom = false;
  bool enableCookies = true;
  Social social = Social();
  String navigationLogoUrl =
      "https://firebasestorage.googleapis.com/v0/b/mini-football-manager-7512c.appspot.com/o/images%2Fb6401430-ac1b-11ec-81b4-9b5036bc270d?alt=media&token=b7683ab0-d6c1-4416-8709-fb57a2202a15";

  bool enableInterstitials = false;
  bool enableBanner = false;
  String iOSBannerID = "";
  String androidBannerID = "";
  String oneSignalAppID = "";
  String oneSignalRestApi = "";
  bool enableBackButtonOnIosDevices = true;
  bool enableShowTitlesAlwaysForBottomMenu = true;
  bool enableShareInSideMenu = true;
  bool allowDownloadingImagesInGallery = true;
  bool disablePermissions = false;
  String sideScreenTitle = "Maverics Labs v2.25";

  General();

  General.fromJson(Map<dynamic, dynamic> json) {
    sideScreenTitle = json['sideScreenTitle'] ?? "Maverics Labs v2.25";
    disablePermissions = json['disablePermissions'] ?? false;
    enableBackButtonOnIosDevices = json['enableBackButtonOnIosDevices'] ?? true;
    enableShowTitlesAlwaysForBottomMenu = json['enableShowTitlesAlwaysForBottomMenu'] ?? true;
    enableShareInSideMenu = json['enableShareInSideMenu'] ?? true;
    allowDownloadingImagesInGallery = json['allowDownloadingImagesInGallery'] ?? true;
    enableLandscape = json['enableLandscape'] ?? false;
    blockVPNUsers = json['blockVPNUsers'] ?? false;
    fontName = json['fontName'] ?? "Roboto";
    reloadWebViewOnBackground = json['reloadWebViewOnBackground'] ?? false;
    oneSignalAppID = json['oneSignalAppID'] ?? "";
    oneSignalRestApi = json['oneSignalRestApi'] ?? "";
    enableScreenSecurity = json['enableExitApp'] ?? false;
    enableExitApp = json['enableExitApp'] ?? false;
    enableToastOnJsAlerts = json['enableToastOnJsAlerts'] ?? true;
    enableCenterTitlesSideScreen = json['enableCenterTitlesSideScreen'] ?? false;
    enableInterstitials = json['enableInterstitials'] ?? false;
    enableBanner = json['enableBanner'] ?? false;
    iOSBannerID = json['iOSBannerID'] ?? "";
    androidBannerID = json['androidBannerID'] ?? "";
    mainURL = json['mainURL'] ?? "https://www.cosmotic.space/";
    shareMsg = json['shareMsg'] ?? "";
    enableHorizontalScroll = json['enableHorizontalScroll'] ?? false;
    enableLoadingWebView = json['enableLoadingWebView'] ?? true;
    enableMultiWindow = json['enableMultiWindow'] ?? false;
    bottomNavigationType = json['bottomNavigationType'] ?? 1;
    enableCookies = json['enableCookies'] ?? true;
    loadingType = json['loadingType'] ?? 1;
    headerRGB = json['headerRGB'].cast<int>();
    headerItemsRGB = json['headerItemsRGB'].cast<int>();
    sideMenuRGB = json['sideMenuRGB'].cast<int>();
    sideMenuItemsRGB = json['sideMenuItemsRGB'].cast<int>();
    if (json['sideMenuHeaderRGB'] != null) {
      sideMenuHeaderRGB = json['sideMenuHeaderRGB'].cast<int>();
    }
    if (json['headerItemsSelectedRGB'] != null) {
      headerItemsSelectedRGB = json['headerItemsSelectedRGB'].cast<int>();
    } else {
      headerItemsSelectedRGB = [0, 0, 0];
    }
    if (json['statusColorRGB'] != null) {
      statusColorRGB = json['statusColorRGB'].cast<int>() ?? [255, 255, 255];
    }
    enableRefreshOnNavigation = json['enableRefreshOnNavigation'] ?? false;
    floatingMenuRGB = json['floatingMenuRGB'].cast<int>();
    floatingIconRGB = json['floatingIconRGB'].cast<int>();
    enabledAdmob = json['enabledAdmob'];
    enabledAnalytics = json['enabledAnalytics'];
    enableSideMenu = json['enableSideMenu'];
    enableFloatingButton = json['enableFloatingButton'];
    enableBottomNavigation = json['enableBottomNavigation'];
    enableCustomJavascript = json['enableCustomJavascript'];
    enableRTL = json['enableRTL'] ?? false;
    customJavascriptCode = json['customJavascriptCode'];
    sideMenuDirection = SlideDirection.values[json["sideMenuDirection"]];
    logoUrl = json['logoUrl'] ??
        "https://firebasestorage.googleapis.com/v0/b/mini-football-manager-7512c.appspot.com/o/images%2Fb0312cf0-ac1b-11ec-81b4-9b5036bc270d?alt=media&token=1e319587-15d2-4f24-b3cf-a2b0e3ddb1d5";
    if (json['enableNoInternetPopup'] != null) {
      enableNoInternetPopup = json['enableNoInternetPopup'];
    } else {
      enableNoInternetPopup = true;
    }

    enableShare = json['enableShare'] ?? true;
    enableTopNavigation = json['enableTopNavigation'] ?? true;
    centerTopTitle = json['centerTopTitle'] ?? true;
    if (json['topNavigationRGB'] != null) {
      topNavigationRGB = json['topNavigationRGB'].cast<int>() ?? [255, 255, 255];
    }
    if (json['androidSystemButtonsColor'] != null) {
      androidSystemButtonsColor = json['androidSystemButtonsColor'].cast<int>() ?? [0, 0, 0];
    }
    if (json['topNavigationItemsRGB'] != null) {
      topNavigationItemsRGB = json['topNavigationItemsRGB'].cast<int>() ?? [0, 0, 0];
    }
    if (json['loadingRGB'] != null) {
      loadingRGB = json['loadingRGB'].cast<int>() ?? [0, 0, 0];
    }
    if (json['applicationColor'] != null) {
      applicationColor = json['applicationColor'].cast<int>() ?? [255, 255, 255];
    }
    if (json['onBoardingRGB'] != null) {
      onBoardingRGB = json['onBoardingRGB'].cast<int>() ?? [255, 255, 255];
    }
    if (json['onBoardingTextRGB'] != null) {
      onBoardingTextRGB = json['onBoardingTextRGB'].cast<int>() ?? [0, 0, 0];
    }
    loadingSize = json['loadingSize'] ?? 30;
    androidAdMobID = json['androidAdMobID'] ?? "";
    iOSAdmobID = json['iOSAdmobID'] ?? "";
    rateAndroidStoreID = json['rateAndroidStoreID'] ?? "";
    rateAppleStoreID = json['rateAppleStoreID'] ?? "";
    enableConstructionMode = json['enableConstructionMode'] ?? false;
    serverKey = json['serverKey'] ?? "";
    instantUpdates = json['instantUpdates'] ?? false;
    pullDownToRefresh = json['pullDownToRefresh'] ?? true;
    customUserAgent = json['customUserAgent'] ?? false;
    customUserAgentString = json['customUserAgentString'] ?? "";
    enableWebRTC = json['enableWebRTC'] ?? false;
    enablePinchZoom = json['enablePinchZoom'] ?? true;
    enableSafeArea = json['enableSafeArea'] ?? false;
    navigationLogoUrl = json['navigationLogoUrl'] ??
        "https://firebasestorage.googleapis.com/v0/b/mini-football-manager-7512c.appspot.com/o/images%2Fb6401430-ac1b-11ec-81b4-9b5036bc270d?alt=media&token=b7683ab0-d6c1-4416-8709-fb57a2202a15";
    if (json['social'] != null) {
      social = Social.fromJson(json['social']);
    }

    if (logoUrl.isEmpty) {
      logoUrl =
          "https://firebasestorage.googleapis.com/v0/b/mini-football-manager-7512c.appspot.com/o/images%2Fb0312cf0-ac1b-11ec-81b4-9b5036bc270d?alt=media&token=1e319587-15d2-4f24-b3cf-a2b0e3ddb1d5";
    }
    if (navigationLogoUrl.isEmpty) {
      navigationLogoUrl =
          "https://firebasestorage.googleapis.com/v0/b/mini-football-manager-7512c.appspot.com/o/images%2Fb6401430-ac1b-11ec-81b4-9b5036bc270d?alt=media&token=b7683ab0-d6c1-4416-8709-fb57a2202a15";
    }
    enableAuthorization = json['enableAuthorization'] ?? false;
    enableFacebookLogin = json['enableFacebookLogin'] ?? false;
    enableGoogleLogin = json['enableGoogleLogin'] ?? false;
    enableEmailLogin = json['enableEmailLogin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sideScreenTitle'] = sideScreenTitle;
    data['disablePermissions'] = disablePermissions;
    data['reloadWebViewOnBackground'] = reloadWebViewOnBackground;
    data['blockVPNUsers'] = blockVPNUsers;
    data['enableLandscape'] = enableLandscape;
    data['enableScreenSecurity'] = enableScreenSecurity;
    data['enableExitApp'] = enableExitApp;
    data['oneSignalAppID'] = oneSignalAppID;
    data['oneSignalRestApi'] = oneSignalRestApi;
    data['enableToastOnJsAlerts'] = enableToastOnJsAlerts;
    data['enableSafeArea'] = enableSafeArea;
    data['loadingType'] = loadingType;
    data['fontName'] = fontName;
    data['enableLoadingWebView'] = enableLoadingWebView;
    data['enableHorizontalScroll'] = enableHorizontalScroll;
    data['enableAuthorization'] = enableAuthorization;
    data['enableFacebookLogin'] = enableFacebookLogin;
    data['enableGoogleLogin'] = enableGoogleLogin;
    data['enableEmailLogin'] = enableEmailLogin;
    data['instantUpdates'] = instantUpdates;
    data['pullDownToRefresh'] = pullDownToRefresh;
    data['enableCookies'] = enableCookies;
    data['loadingRGB'] = loadingRGB.cast<int>();
    data['applicationColor'] = applicationColor.cast<int>();
    data['loadingSize'] = loadingSize;
    data['customUserAgent'] = customUserAgent;
    data['customUserAgentString'] = customUserAgentString;
    data['bottomNavigationType'] = bottomNavigationType;
    data['enableWebRTC'] = enableWebRTC;
    data['enableRTL'] = enableRTL;
    data['enableCenterTitlesSideScreen'] = enableCenterTitlesSideScreen;
    data['enablePinchZoom'] = enablePinchZoom;
    data['mainURL'] = mainURL;
    data['shareMsg'] = shareMsg;
    data['enableShare'] = enableShare;
    data['iOSAdmobID'] = iOSAdmobID;
    data['enableMultiWindow'] = enableMultiWindow;
    data['androidAdMobID'] = androidAdMobID;
    data['enableTopNavigation'] = enableTopNavigation;
    data['centerTopTitle'] = centerTopTitle;
    data['headerRGB'] = headerRGB.cast<int>();
    data['headerItemsRGB'] = headerItemsRGB.cast<int>();
    data['sideMenuRGB'] = sideMenuRGB.cast<int>();
    data['sideMenuItemsRGB'] = sideMenuItemsRGB.cast<int>();
    data['sideMenuHeaderRGB'] = sideMenuHeaderRGB.cast<int>();
    data['floatingMenuRGB'] = floatingMenuRGB.cast<int>();
    data['floatingIconRGB'] = floatingIconRGB.cast<int>();
    data['topNavigationRGB'] = topNavigationRGB.cast<int>();
    data['topNavigationItemsRGB'] = topNavigationItemsRGB.cast<int>();
    data['onBoardingRGB'] = onBoardingRGB.cast<int>();
    data['onBoardingTextRGB'] = onBoardingTextRGB.cast<int>();
    data['androidSystemButtonsColor'] = androidSystemButtonsColor.cast<int>();
    data['headerItemsSelectedRGB'] = headerItemsSelectedRGB.cast<int>();
    data['enabledAdmob'] = enabledAdmob;
    data['enabledAnalytics'] = enabledAnalytics;
    data['enableSideMenu'] = enableSideMenu;
    data['enableBottomNavigation'] = enableBottomNavigation;
    data['enableCustomJavascript'] = enableCustomJavascript;
    data['customJavascriptCode'] = customJavascriptCode;
    data['sideMenuDirection'] = sideMenuDirection.index;
    data['enableNoInternetPopup'] = enableNoInternetPopup;
    data['enableFloatingButton'] = enableFloatingButton;
    data['logoUrl'] = logoUrl;
    data['rateAndroidStoreID'] = rateAndroidStoreID;
    data['rateAppleStoreID'] = rateAppleStoreID;
    data['enableConstructionMode'] = enableConstructionMode;
    data['serverKey'] = serverKey;
    data['social'] = social.toJson();
    data['navigationLogoUrl'] = navigationLogoUrl;
    data['enableInterstitials'] = enableInterstitials;
    data['enableBanner'] = enableBanner;
    data['iOSBannerID'] = iOSBannerID;
    data['androidBannerID'] = androidBannerID;
    data['enableBackButtonOnIosDevices'] = enableBackButtonOnIosDevices;
    data['enableShowTitlesAlwaysForBottomMenu'] = enableShowTitlesAlwaysForBottomMenu;
    data['enableShareInSideMenu'] = enableShareInSideMenu;
    data['allowDownloadingImagesInGallery'] = allowDownloadingImagesInGallery;
    return data;
  }

  Color getHeaderColor() {
    return Color.fromRGBO(headerRGB[0], headerRGB[1], headerRGB[2], 1);
  }

  Color getHeaderItemsColor() {
    return Color.fromRGBO(headerItemsRGB[0], headerItemsRGB[1], headerItemsRGB[2], 1);
  }

  Color getHeaderSelectedItemsColor() {
    return Color.fromRGBO(headerItemsSelectedRGB[0], headerItemsSelectedRGB[1], headerItemsSelectedRGB[2], 1);
  }

  Color getSideMenuColor() {
    return Color.fromRGBO(sideMenuRGB[0], sideMenuRGB[1], sideMenuRGB[2], 1);
  }

  Color getSideMenuItemColor() {
    return Color.fromRGBO(sideMenuItemsRGB[0], sideMenuItemsRGB[1], sideMenuItemsRGB[2], 1);
  }

  Color getSideMenuItemColorWithAlpha() {
    return Color.fromRGBO(sideMenuItemsRGB[0], sideMenuItemsRGB[1], sideMenuItemsRGB[2], 0.7);
  }

  Color getSideMenuItemColorLowAlpha() {
    return Color.fromRGBO(sideMenuItemsRGB[0], sideMenuItemsRGB[1], sideMenuItemsRGB[2], 0.1);
  }

  Color getSideMenuHeaderColor() {
    return Color.fromRGBO(sideMenuHeaderRGB[0], sideMenuHeaderRGB[1], sideMenuHeaderRGB[2], 1);
  }

  Color getFloatingMenuColor() {
    return Color.fromRGBO(floatingMenuRGB[0], floatingMenuRGB[1], floatingMenuRGB[2], 1);
  }

  Color getFloatingIconColor() {
    return Color.fromRGBO(floatingIconRGB[0], floatingIconRGB[1], floatingIconRGB[2], 1);
  }

  Color getTopNavigationColor() {
    return Color.fromRGBO(topNavigationRGB[0], topNavigationRGB[1], topNavigationRGB[2], 1);
  }

  Color getTopNavigationItemColor() {
    return Color.fromRGBO(topNavigationItemsRGB[0], topNavigationItemsRGB[1], topNavigationItemsRGB[2], 1);
  }

  Color getOnBoardingColor() {
    return Color.fromRGBO(onBoardingRGB[0], onBoardingRGB[1], onBoardingRGB[2], 1);
  }

  Color getOnBoardingTextColor() {
    return Color.fromRGBO(onBoardingTextRGB[0], onBoardingTextRGB[1], onBoardingTextRGB[2], 1);
  }

  Color getStatusColor() {
    return Color.fromRGBO(statusColorRGB[0], statusColorRGB[1], statusColorRGB[2], 1);
  }

  Color getLoadingColor() {
    return Color.fromRGBO(loadingRGB[0], loadingRGB[1], loadingRGB[2], 1);
  }

  Color getApplicationColor() {
    return Color.fromRGBO(applicationColor[0], applicationColor[1], applicationColor[2], 1);
  }

  Color getAndroidSystemButtonsColor() {
    return Color.fromRGBO(androidSystemButtonsColor[0], androidSystemButtonsColor[1], androidSystemButtonsColor[2], 1);
  }
}
