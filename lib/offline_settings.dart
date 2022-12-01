import 'dart:convert';

import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/models/woo_config.dart';

import 'models/localization.dart';
import 'models/onboaring_page.dart';
import 'models/side_item.dart';
import 'models/splash.dart';
import 'models/welcome_popup.dart';

class OfflineSettings {
  //Enable or disable from here the offline mode
  bool enableOfflineMode = false;

  //Apply these values from the admin panel under section Offline Export
  //IMPORTANT keep the three quotes """here add the values!Must always start and end with three quotes"""
  String generalSettings =
      """{"enableExitApp":true,"enableToastOnJsAlerts":true,"enableSafeArea":false,"enableHorizontalScroll":false,"enableLoadingWebView":true,"bottomNavigationType":2,"enableAuthorization":false,"enableFacebookLogin":true,"enableGoogleLogin":true,"enableEmailLogin":true,"instantUpdates":true,"loadingType":3,"pullDownToRefresh":true,"customUserAgent":false,"customUserAgentString":"","enableWebRTC":false,"enableMultiWindow":true,"enablePinchZoom":false,"mainURL":"https://testpages.herokuapp.com/styled/alerts/alert-test.html","shareMsg":"Hey check out this awesome app. You can do so much with it..","enableShare":true,"iOSAdmobID":"ca-app-pub-3940256099942544/1033173712","enableScreenSecurity":true,"enableRTL":false,"androidAdMobID":"ca-app-pub-3940256099942544/1033173712","enableTopNavigation":true,"centerTopTitle":true,"headerRGB":[0,0,0],"headerItemsRGB":[255,255,255],"sideMenuRGB":[255,255,255],"sideMenuItemsRGB":[0,0,0],"sideMenuHeaderRGB":[0,0,0],"floatingMenuRGB":[0,0,0],"floatingIconRGB":[255,255,255],"topNavigationRGB":[0,0,0],"topNavigationItemsRGB":[255,255,255],"statusColorRGB":[0,0,0],"loadingRGB":[0,0,0],"applicationColor":[255,255,255],"loadingSize":30,"enableRefreshOnNavigation":false,"enabledAdmob":false,"enabledAnalytics":true,"enableSideMenu":true,"enableBottomNavigation":true,"enableCustomJavascript":false,"customJavascriptCode":"","sideMenuDirection":0,"enableNoInternetPopup":false,"enableFloatingButton":false,"logoUrl":"","rateAndroidStoreID":"","rateAppleStoreID":"","enableConstructionMode":false,"serverKey":"","social":{"facebook":"https://facebook.com","instagram":"https://instagram.com","twitter":"https://twitter.com","pinterest":"https://pinterest.com","linkedin":"","tiktok":"","youtube":"","vimeo":""},"navigationLogoUrl":"","enableCookies":true,"enableInterstitials":false,"enableBanner":true,"iOSBannerID":"ca-app-pub-3940256099942544/2934735716","androidBannerID":"ca-app-pub-3940256099942544/6300978111"}""";
  String applicationSettings =
      """{"popup":{"title":"This is welcome popup","text":"This is welcome popup This is welcome popup This is welcome popup ","imageUrl":"https://firebasestorage.googleapis.com/v0/b/vishop-d1421.appspot.com/o/images%2Fecee39d0-ba53-11ec-b83e-a7fd80808f62?alt=media&token=5a104a14-aa94-48e7-8245-28b3db86a861","isEnabled":false},"splash":{"imageUrl":"","splashColor":[255,255,255]},"localizations":{"userNameIsRequired":"Username is required!","waitWeNeedYourName":"Wait we need your name","yourNameHere":"Type your name here","joinButton":"Join","skip":"Skip","theMostAdvanced":"The most advanced web converter!","continueText":"Continue","oops":"Oops","slowConnection":"Slow or no internet connection","checkInternet":"Please check your internet settings","okButton":"Ok","weAreUnderMaintenance":"We are under maintenance","ourAppIsInMaintenance":"Our app is currently under maintenance","weWillBeBackShortly":"We will be back shortly!","gotItThankYou":"Got it! Thank you!","writeMessage":"Write message","authLetsGetYouIn":"Let's get you in!","authLoginToYourAccount":"Login to your account.","authThisFieldCantBeEmpty":"This field can't be empty","authEmail":"E-mail","authPass":"Password","authForgotPass":"Forgot Password?","authSignIn":"Sign in","authLoginGoogle":"Login with Google","authLoginFacebook":"Login with Facebook","authDontHaveAccount":"Don't have an account?","authSignUp":"Sign up","authInvalidPassword":"The password is invalid or the user does not have password","authEmailRequired":"Email is required","authFullName":"Full name","authFillForm":"Please fill the form to continue","authNewHere":"New here? Welcome!","authResetEmail":"Reset email is sent!","authEmailNotFound":"Email not found","authAccountExist":"Account already exist, but with different login type","yesButton":"Yes, let's do it","noButton":"Nope","exitMessageTitle":"Hey, you are leaving us?","exitMessageSubtitle":"Do you want to exit?","wooBuyNow":"Buy now","wooProductDetails":"Product Details33","wooFirstName":"First name","wooLastName":"Last name","wooAddressName":"Address","wooPhone":"Phone number","wooCountry":"Contry","wooState":"State","wooCity":"City","wooPostCode":"Post code","wooPayStripe":"Pay now with Stripe","wooPayDelivery":"Pay on delivery","wooOr":"or","wooOrderSuccess":"Order success! Thank you for being our customer!","wooShippingAddress":"Shipping address","exitTitle":"Hey, are you leaving us?","exitSubtitle":"Are you sure?","exitYes":"Yes, Exit now","exitNo":"No, I'm staying","pageErrorTitle":"Look's like we hit a storm, there is a problem with this page","pageErrorButtonBack":"Go back","pageErrorButtonRefresh":"Refresh"},"items":[{"youtubeVideos":[],"uid":"","title":"Home","text":"","latitude":"","longitude":"","link":"","type":5,"address":"","customJS":"","iconCode":61461,"fontFamily":"FontAwesomeSolid","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[],"uid":"","title":"Appointments","text":"","latitude":"","longitude":"","link":"","type":19,"address":"","customJS":"","iconCode":62068,"fontFamily":"FontAwesomeRegular","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[{"videoID":"1_4yRoSEAUU","videoTitle":"Audi A8L - The most luxury car ever made","isLive":true,"autoPlay":true,"hideControls":false,"forceHD":true},{"videoID":"tgB1wUcmbbw","videoTitle":"Thor new teaser available now (ULTRA HD)","isLive":false,"autoPlay":false,"hideControls":false,"forceHD":true}],"uid":"","title":"videos","text":"","latitude":"","longitude":"","link":"","type":17,"address":"","customJS":"","iconCode":61799,"fontFamily":"FontAwesomeBrands","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[],"uid":"","title":"Radio Stream","text":"","latitude":"","longitude":"","link":"http://stream-uk1.radioparadise.com/aac-320","type":16,"address":"","customJS":"","iconCode":63703,"fontFamily":"FontAwesomeSolid","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""}],"navItems":[{"youtubeVideos":[],"uid":"","title":"Home","text":"","latitude":"","longitude":"","link":"","type":5,"address":"","customJS":"","iconCode":61461,"fontFamily":"FontAwesomeSolid","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[],"uid":"","title":"Shop","text":"","latitude":"","longitude":"","link":"","type":11,"address":"","customJS":"","iconCode":62799,"fontFamily":"FontAwesomeSolid","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[],"uid":"","title":"Posts","text":"","latitude":"","longitude":"","link":"mavericslabs.com","type":15,"address":"","customJS":"","iconCode":62481,"fontFamily":"FontAwesomeBrands","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[],"uid":"","title":"Radio","text":"","latitude":"","longitude":"","link":"http://stream-uk1.radioparadise.com/aac-320","type":16,"address":"","customJS":"","iconCode":63703,"fontFamily":"FontAwesomeSolid","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""},{"youtubeVideos":[{"videoID":"UF-pmIlgEb0","videoTitle":"FERRARI 812 Superfast *340KMH* REVIEW on AUTOBAHN [NO SPEED LIMIT] by AutoTopNL","isLive":false,"autoPlay":false,"hideControls":false,"forceHD":true},{"videoID":"oGVZyA8tkSY","videoTitle":"2022 Tesla Model X Presentation Plaid and Long Range","isLive":false,"autoPlay":false,"hideControls":false,"forceHD":true},{"videoID":"tgB1wUcmbbw","videoTitle":"Marvel Studios' Thor: Love and Thunder | Official Teaser","isLive":false,"autoPlay":false,"hideControls":false,"forceHD":true},{"videoID":"xg832guA-gQ","videoTitle":"The New Mercedes C Class 2022 Test Drive","isLive":false,"autoPlay":false,"hideControls":false,"forceHD":true}],"uid":"","title":"YouTube","text":"","latitude":"","longitude":"","link":"","type":17,"address":"","customJS":"","iconCode":61799,"fontFamily":"FontAwesomeBrands","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""}],"floatingItems":[{"youtubeVideos":[],"uid":"","title":"Support","text":"","latitude":"","longitude":"","link":"","type":8,"address":"","customJS":"","iconCode":58626,"fontFamily":"FontAwesomeSolid","enableLogoAndTitle":false,"enableFooter":false,"categoryID":"","tagID":"","iconPrefix":""}],"onBoardingPages":[{"title":"This is onboarding title","text":"We have a dramatically reduced prices over the entire shop. Take a look now.","imageUrl":"https://firebasestorage.googleapis.com/v0/b/vishop-d1421.appspot.com/o/images%2F44eeff90-c0b5-11ec-88a4-6dfc3aca24c8?alt=media&token=f6c96a5b-6da9-4112-87b8-9fbc25e03a6e"}],"gallery_images":["https://firebasestorage.googleapis.com/v0/b/vishop-d1421.appspot.com/o/images%2F34804230-b65c-11ec-9b93-272079cceabc?alt=media&token=3e6ba9fc-a7b2-4fe7-914b-b09d25ea12db","https://firebasestorage.googleapis.com/v0/b/vishop-d1421.appspot.com/o/images%2F2f884930-b65c-11ec-9b93-272079cceabc?alt=media&token=7f12d400-1c17-47bf-a530-fa91c5e6d506","https://firebasestorage.googleapis.com/v0/b/vishop-d1421.appspot.com/o/images%2F29337f50-b65c-11ec-9b93-272079cceabc?alt=media&token=020b52bb-b153-47ea-a6c0-93532ee30479"]}""";
  String wooCommerceSettings =
      """{"website":"https://mavericslabs.com","wooKey":"ck_1fb343f74683f3ab1b3277fbad6041d780717a13","wooSecret":"cs_33b47d6a4aeffd6dfad3228841c103142ba631db","currency":"","stripeSecretKey":"sk_test_51INxFgBs5GGVPtMPwbMjUYIU1MAYZtt89ye0WEb8diBLrzmUImBmOLmqcaCAnAg97l7UGZY77mLR2m5PCWcKXmy000PKWVJky9","enableWooAuthorization":false,"enablePayments":true,"enableStripe":false,"enablePayOnDelivery":true,"enableStoreCurrency":false,"stripePublishableKey":"pk_test_51INxFgBs5GGVPtMPtmJTU8cbDadCDEjN6Tz44iPqSwcDMP1TW4dge6801Czqkq6d7v8S190NGDoKXvapLqgheYrb00RSBXPohN","stripeShopName":"Maverics Shop","stripeCountryCode":"US"}""";

  General getGeneralSettings() {
    return General.fromJson(json.decode(generalSettings));
  }

  AppOptions getApplicationSettings() {
    List<SideItem> sideItems = [];
    List<SideItem> navItems = [];
    List<SideItem> floatingItems = [];
    List<OnboardingPage> onBoardingPages = [];
    List<String> images = [];

    Map<dynamic, dynamic> itemsMaps = json.decode(applicationSettings);

    if (itemsMaps['items'] != null) {
      List<dynamic> snapshotItems = itemsMaps["items"] as List<dynamic>;
      for (var element in snapshotItems) {
        SideItem item = SideItem.fromJson(element);
        sideItems.add(item);
      }
    }

    if (itemsMaps['navItems'] != null) {
      List<dynamic> snapshotNavItems = itemsMaps["navItems"] as List<dynamic>;
      for (var element in snapshotNavItems) {
        SideItem item = SideItem.fromJson(element);
        navItems.add(item);
      }
    }

    if (itemsMaps['floatingItems'] != null) {
      List<dynamic> snapshotFloatingItems = itemsMaps["floatingItems"] as List<dynamic>;
      for (var element in snapshotFloatingItems) {
        SideItem item = SideItem.fromJson(element);
        floatingItems.add(item);
      }
    }

    if (itemsMaps['gallery_images'] != null) {
      List<dynamic> snapshotFloatingItems = itemsMaps["gallery_images"] as List<dynamic>;
      for (var element in snapshotFloatingItems) {
        String image = element;
        images.add(image);
      }
    }

    if (itemsMaps['onBoardingPages'] != null) {
      List<dynamic> snapshotFloatingItems = itemsMaps["onBoardingPages"] as List<dynamic>;
      for (var element in snapshotFloatingItems) {
        OnboardingPage item = OnboardingPage.fromJson(element);
        onBoardingPages.add(item);
      }
    }

    AppOptions helper = AppOptions();
    helper.sideItems = sideItems;
    helper.navItems = navItems;
    helper.floatingItems = floatingItems;
    helper.onboardingPages = onBoardingPages;
    helper.imageUrls = images;

    if (itemsMaps["popup"] != null) {
      WelcomePopup popup = WelcomePopup.fromJson(itemsMaps["popup"]);
      helper.popup = popup;
    }

    if (itemsMaps["splash"] != null) {
      Splash splash = Splash.fromJson(itemsMaps["splash"]);
      helper.splash = splash;
    }

    if (itemsMaps["localizations"] != null) {
      helper.localization = Localization.fromJson(itemsMaps["localizations"]);
    }
    return helper;
  }

  WooConfig getWooCommerceSettings() {
    return WooConfig.fromJson(json.decode(wooCommerceSettings));
  }
}
