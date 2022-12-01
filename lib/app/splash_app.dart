import 'dart:async';

import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/custom_localization.dart';
import 'package:be_app_mobile/models/localization.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/service/woocommerce_service.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboaring_page.dart';
import '../screens/select_language_screen.dart';
import '../service/api_service.dart';
import '../widgets/permissions_widget.dart';
import 'mobile_app.dart';

class SplashApp extends StatefulWidget {
  const SplashApp({Key? key, required this.beApp}) : super(key: key);
  final BeAppModel beApp;
  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  bool isLoggedIn = false;
  bool isLanguageSelected = false;
  String title = "";
  @override
  void initState() {
    title = mainLocalization.localization.skip;
    widget.beApp.isLanguageSelected = widget.beApp.options.customLocalizations.isNotEmpty ? false : true;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: widget.beApp.general.getAndroidSystemButtonsColor(),
      statusBarColor: widget.beApp.general.getTopNavigationColor(),
      systemNavigationBarDividerColor: widget.beApp.general.getAndroidSystemButtonsColor(),
    ));
    super.initState();
    loadStoreCurrency();
    loadAppSettings();
    checkForPermissions();
  }

  void checkForPermissions() async {
    if (widget.beApp.general.disablePermissions == false || widget.beApp.general.enableWebRTC == true) {
      if (await Permission.camera.isGranted == false || await Permission.microphone.isGranted == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PermissionsWidget(
              options: widget.beApp.options,
              general: widget.beApp.general,
            ),
          ),
        );
      }
    }
  }

  Widget loadFirstRun() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Loading(
              general: widget.beApp.general,
            );
          case ConnectionState.waiting:
            return Loading(
              general: widget.beApp.general,
            );
          case ConnectionState.done:
            FlutterNativeSplash.remove();
            if (!snapshot.hasError) {
              return isLanguageSelected == false
                  ? SelectLanguageScreen(
                      model: widget.beApp,
                      onLanguageSelected: (Localization localization) {
                        setState(() {
                          isLanguageSelected = true;
                          widget.beApp.options.localization = localization;
                          widget.beApp.isLanguageSelected = true;
                          title = localization.skip;
                          widget.beApp.general.enableRTL = isRTL;
                        });
                      },
                    )
                  : loadStartingScreen();
            } else {
              return Loading(
                general: widget.beApp.general,
              );
            }
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
        }
        return Loading(
          general: widget.beApp.general,
        );
      },
    );
  }

  Widget loadStartingScreen() {
    return widget.beApp.options.onboardingPages.isEmpty
        ? BeApp(
            beAppModel: widget.beApp,
          )
        : isLoggedIn
            ? BeApp(
                beAppModel: widget.beApp,
              )
            : Scaffold(backgroundColor: Colors.white, body: onBoardingScreen());
  }

  Widget onBoardingScreen() {
    return IntroductionScreen(
      pages: onBoardingPages(),
      globalBackgroundColor: widget.beApp.general.getOnBoardingColor(),
      onDone: () async {
        moveToApp();
      },
      onSkip: () async {
        moveToApp();
      },
      showBackButton: false,
      showSkipButton: true,
      showNextButton: false,
      skip: Text(
        mainLocalization.localization.skip,
        style: getFontStyle(14, widget.beApp.general.getOnBoardingTextColor(), FontWeight.bold, widget.beApp.general),
      ),
      done: Text(
        mainLocalization.localization.continueText,
        style: getFontStyle(14, widget.beApp.general.getOnBoardingTextColor(), FontWeight.bold, widget.beApp.general),
      ),
    );
  }

  moveToApp() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.setBool("isFirstRun", true);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BeApp(
                  beAppModel: widget.beApp,
                )));
  }

  List<PageViewModel> onBoardingPages() {
    return List.generate(widget.beApp.options.onboardingPages.length, (index) {
      OnboardingPage page = widget.beApp.options.onboardingPages[index];
      PageViewModel model = PageViewModel(
        title: page.title,
        body: page.text,
        decoration: PageDecoration(
          pageColor: widget.beApp.general.getOnBoardingColor(),
          titleTextStyle: getFontStyle(20, widget.beApp.general.getOnBoardingTextColor(), FontWeight.bold, widget.beApp.general),
          bodyTextStyle: getFontStyle(18, widget.beApp.general.getOnBoardingTextColor(), FontWeight.normal, widget.beApp.general),
        ),
        image: Center(
          child: BeImage(
            link: page.imageUrl,
            width: 330,
            height: 330,
            fit: BoxFit.cover,
          ),
        ),
      );
      return model;
    });
  }

  loadAppSettings() async {
    isLoggedIn = await MySharedPreferences.instance.getBooleanValue("isFirstRun");
    isLanguageSelected = await MySharedPreferences.instance.getBooleanValue("isLanguageSelected");
    if (!isLoggedIn) {
      APIService().logEvent(AnalyticsType.device);
    } else {}
    if (isLanguageSelected) {
      if (widget.beApp.options.customLocalizations.length > 1) {
        int selectedLanguageIndex = await MySharedPreferences.instance.getSelectedLanguage();
        mainLocalization = widget.beApp.options.customLocalizations[selectedLanguageIndex];
        isRTL = widget.beApp.options.customLocalizations[selectedLanguageIndex].isRTL;
        widget.beApp.options.localization = widget.beApp.options.customLocalizations[selectedLanguageIndex].localization;
      }
    } else {
      if (widget.beApp.options.customLocalizations.length == 1) {
        isLanguageSelected = true;
      }
      mainLocalization = CustomLocalization(name: "English", localization: widget.beApp.options.localization);
      isRTL = widget.beApp.general.enableRTL;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: loadFirstRun());
    } else {
      return loadFirstRun();
    }
  }

  bool shouldShowPermissionWidget() {
    if (widget.beApp.general.disablePermissions == false) {
      if (widget.beApp.general.enableWebRTC) {
        return true;
      }
    }
    return false;
  }

  void loadStoreCurrency() async {
    if (website.isNotEmpty) {
      storeCurrency = await WooService().getStoreCurrency();
    }
  }
}

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance = MySharedPreferences._privateConstructor();
  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }

  Future<int> getSelectedLanguage() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt("SelectedLanguage") ?? 0;
  }

  setSelectedLanguage(int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt("SelectedLanguage", value);
  }
}
