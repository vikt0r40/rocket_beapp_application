import 'dart:async';
import 'dart:io';

import 'package:be_app_mobile/app/splash_app.dart';
import 'package:be_app_mobile/autorization/pages/login_page.dart';
import 'package:be_app_mobile/autorization/service/auth_service.dart';
import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/helpers/social_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/woo_config.dart';
import 'package:be_app_mobile/offline_settings.dart';
import 'package:be_app_mobile/screens/items/about_us.dart';
import 'package:be_app_mobile/screens/items/chat_screen.dart';
import 'package:be_app_mobile/screens/items/error_page.dart';
import 'package:be_app_mobile/screens/items/gallery_screen.dart';
import 'package:be_app_mobile/screens/items/qr_code_screen.dart';
import 'package:be_app_mobile/screens/items/radio_stream.dart';
import 'package:be_app_mobile/screens/items/settings/settings_screen.dart';
import 'package:be_app_mobile/screens/items/video_screen.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_products.dart';
import 'package:be_app_mobile/screens/items/wordpress/wp_posts_screen.dart';
import 'package:be_app_mobile/screens/items/youtube_videos.dart';
import 'package:be_app_mobile/screens/select_language_screen.dart';
import 'package:be_app_mobile/screens/side_screen.dart';
import 'package:be_app_mobile/service/admob_service.dart';
import 'package:be_app_mobile/service/api_service.dart';
import 'package:be_app_mobile/service/product_provider.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:be_app_mobile/widgets/no_internet.dart';
import 'package:be_app_mobile/widgets/welcome_popup_widget.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:share/share.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/general.dart';
import '../models/localization.dart';
import '../models/side_item.dart';
import '../widgets/be_button.dart';
import '../widgets/vpn_restriction.dart';
import 'items/feedback_screen.dart';
import 'items/location_screen.dart';
import 'items/text_screen.dart';

class MobileScreen extends StatefulWidget {
  final General general;
  final AppOptions appOptions;
  final WooConfig wooConfig;
  const MobileScreen({Key? key, required this.general, required this.appOptions, required this.wooConfig}) : super(key: key);

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isLoading = true;
  late FirebaseMessaging messaging;
  final GlobalKey _wooKey = GlobalKey();
  InAppWebViewController? webViewController;
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  AdmobService admobService = AdmobService(appleID: "", androidID: "");
  late String title;
  SideItem item = SideItem(title: "Home");
  SideItem previousItem = SideItem(title: "Home");

  final InAppReview inAppReview = InAppReview.instance;
  int _selectedIndex = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;
  int adCounter = 0;
  int adClicks = 3;
  double webViewHeight = 10;
  late BannerAd myBanner;
  bool adShow = false;
  late BannerAd _ad;
  bool isVPNActive = false;
  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
    if (widget.general.blockVPNUsers) {
      checkVPNConnection();
    }
    if (widget.appOptions.customLocalizations.isNotEmpty) {
      widget.appOptions.localization = mainLocalization.localization;
    }
    if (widget.general.enabledAdmob && widget.general.enableBanner) {
      _ad = BannerAd(
        adUnitId: UniversalPlatform.isAndroid ? widget.general.androidBannerID : widget.general.iOSBannerID,
        size: AdSize.fullBanner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              adShow = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Releases an ad resource when it fails to load
            ad.dispose();

            debugPrint('Ad load failed (code=${error.code} message=${error.message})');
          },
        ),
      );

      // TODO: Load an ad
      _ad.load();
    }
    if (widget.general.enableNoInternetPopup) {
      initConnectivity();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    }

    if (widget.general.enabledAdmob && widget.general.enableInterstitials) {
      admobService.appleID = widget.general.iOSAdmobID;
      admobService.androidID = widget.general.androidAdMobID;
      admobService.createInterstitialAd();
    }
    title = "";
    item.type = ItemType.home;
    item.link = widget.general.mainURL;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    // if (UniversalPlatform.isAndroid) WebView.platform = AndroidWebView();
    OfflineSettings settings = OfflineSettings();
    if (settings.enableOfflineMode == false) {
      messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) {
        messaging.subscribeToTopic("messaging");
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(event.notification!.title ?? "Notification"),
                content: Text(event.notification!.body!),
                actions: [
                  TextButton(
                    child: Text(mainLocalization.localization.gotItThankYou),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    }
    showWelcomePopup();
    if (widget.general.enabledAnalytics) {
      APIService().logEvent(AnalyticsType.visitors);
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: widget.general.getStatusColor()));

    if (widget.general.enableScreenSecurity) {
      ScreenProtector.preventScreenshotOn();
    } else {
      ScreenProtector.preventScreenshotOff();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_connectivitySubscription != null) {
      _connectivitySubscription?.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (widget.general.reloadWebViewOnBackground) {
      webViewController?.reload();
    }
    if (widget.general.blockVPNUsers) {
      checkVPNConnection();
    }
  }

  void _onItemTapped(int index) {
    checkForLoad(item);
    if (mounted) {
      setState(() {
        //_selectedPage = index;
        _selectedIndex = index;
        previousItem = item;
        item = widget.appOptions.navItems[index];
      });
      if (item.type != ItemType.rateUs) {
        title = item.title;
      }
      if (item.type == ItemType.social) {
        launchUrl(Uri.parse(item.link));
      } else if (item.type == ItemType.phone) {
        String phone = "tel://${item.text}";
        launchUrl(Uri.parse(phone));
      }
    }
  }

  bool isInitialLoaded = false;
  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: homeWidget());
    } else {
      return homeWidget();
    }
  }

  void blockVPNUser() async {
    if (isVPNActive == false) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VPNRestrictionScreen(
                    options: widget.appOptions,
                    general: widget.general,
                  )));
    }
  }

  void checkVPNConnection() async {
    debugPrint("VPN CHECK ENABLED");
    if (await CheckVpnConnection.isVpnActive()) {
      isVPNActive = true;
      debugPrint("VPN DETECTED... BLOCKING USER");
      blockVPNUser();
    } else {
      isVPNActive = false;
    }
  }

  Widget homeWidget() {
    return WillPopScope(
      onWillPop: () async {
        bool? canGoBack = await webViewController?.canGoBack();
        Uri? url = await webViewController?.getOriginalUrl();
        if (url.toString() == widget.general.mainURL) {
          await showExitPopupAlert();
        } else if (canGoBack == false) {
          await showExitPopupAlert();
        } else {
          webViewController?.goBack();
        }
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: widget.general.enableTopNavigation == false
              ? null
              : AppBar(
                  //elevation: 0,
                  title: SizedBox(
                    width: 150,
                    height: 44,
                    child: BeImage(
                      link: widget.general.navigationLogoUrl,
                      width: 150,
                      height: 44,
                    ),
                  ),
                  iconTheme: IconThemeData(color: widget.general.getTopNavigationItemColor()),
                  centerTitle: widget.general.centerTopTitle,
                  backgroundColor: widget.general.getTopNavigationColor(),
                  actions: navigationButtons(),
                ),
          backgroundColor: widget.general.getApplicationColor(),
          drawer: widget.general.enableSideMenu == false
              ? null
              : Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                  child: Opacity(
                    opacity: 0.94,
                    child: Drawer(
                      backgroundColor: widget.general.getSideMenuColor(),
                      child: SideScreen(
                        general: widget.general,
                        appOptions: widget.appOptions,
                        onItemClick: (SideItem selectedItem) {
                          if (mounted) {
                            setState(() {
                              previousItem = item;
                              item = selectedItem;
                              if (item.type != ItemType.rateUs) {
                                title = item.title;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
          floatingActionButtonLocation: adShow ? FloatingActionButtonLocation.endFloat : FloatingActionButtonLocation.endDocked,
          floatingActionButton: widget.general.enableFloatingButton
              ? Visibility(
                  visible: item.type == ItemType.chat ? false : true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionBubble(
                        items: floatingItems(),
                        animation: _animation,
                        onPress: () => _animationController.isCompleted ? _animationController.reverse() : _animationController.forward(),
                        iconColor: widget.general.getFloatingIconColor(),
                        iconData: Icons.menu,
                        backGroundColor: widget.general.getFloatingMenuColor(),
                      ),
                      SizedBox(
                        height: widget.general.enableBottomNavigation ? 70 : 20,
                      ),
                    ],
                  ))
              : null,
          bottomNavigationBar: widget.general.enableBottomNavigation && widget.appOptions.navItems.length >= 2 ? selectedNavBar() : null,
          body: widget.general.enableSafeArea ? SafeArea(child: mainStack()) : mainStack()),
    );
  }

  showExitPopupAlert() async {
    bool isLeaving = await showExitPopup();
    if (isLeaving) {
      if (widget.general.enableExitApp) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  Widget mainStack() {
    return Stack(
      children: [
        mainWidget(),
        Visibility(
            visible: _connectionStatus == ConnectivityResult.none,
            child: NoInternet(
              options: widget.appOptions,
              general: widget.general,
            ))
      ],
    );
  }

  Widget selectedNavBar() {
    if (widget.general.bottomNavigationType == 1) {
      return bottomNavigationBar();
    } else {
      return classicBottomNavigation();
    }
  }

  List<IconButton> navigationButtons() {
    List<IconButton> buttons = [];

    if (widget.general.enableShare) {
      buttons.add(IconButton(
        onPressed: () {
          Share.share(widget.general.shareMsg);
          if (widget.general.enabledAnalytics) {
            APIService().logEvent(AnalyticsType.userShares);
          }
        },
        icon: FaIcon(
          FontAwesomeIcons.share,
          color: widget.general.getTopNavigationItemColor(),
          size: 15,
        ),
      ));
    }
    if (widget.general.enableAuthorization) {
      buttons.add(IconButton(
        onPressed: () {
          signOutAction();
        },
        icon: FaIcon(
          FontAwesomeIcons.rightFromBracket,
          color: widget.general.getTopNavigationItemColor(),
          size: 15,
        ),
      ));
    }
    if (widget.general.enableRefreshOnNavigation) {
      buttons.add(IconButton(
        onPressed: () {
          webViewController?.reload();
        },
        icon: FaIcon(
          FontAwesomeIcons.rotate,
          size: 15,
          color: widget.general.getTopNavigationItemColor(),
        ),
      ));
    }
    if (widget.general.enableBackButtonOnIosDevices && UniversalPlatform.isIOS) {
      buttons.add(IconButton(
        onPressed: () async {
          bool? canGoBack = await webViewController?.canGoBack();
          if (canGoBack == true) {
            webViewController?.goBack();
          }
        },
        icon: FaIcon(
          FontAwesomeIcons.arrowLeft,
          size: 15,
          color: widget.general.getTopNavigationItemColor(),
        ),
      ));
    }
    return buttons;
  }

  Widget bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: widget.general.getHeaderColor(),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
          child: GNav(
            gap: 5,
            activeColor: Colors.black,
            style: GnavStyle.google,
            iconSize: 15,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: widget.general.getHeaderColor(),
            backgroundColor: widget.general.getHeaderColor(),
            tabs: navItems(),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              _onItemTapped(index);
            },
          ),
        ),
      ),
    );
  }

  Widget classicBottomNavigation() {
    return BottomNavigationBar(
      items: classicNavItems(),
      type: widget.general.enableShowTitlesAlwaysForBottomMenu
          ? BottomNavigationBarType.fixed
          : BottomNavigationBarType.shifting, //fixed to show all labels
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: widget.general.getHeaderColor(),
      selectedItemColor: widget.general.enableShowTitlesAlwaysForBottomMenu == false ? null : widget.general.getHeaderSelectedItemsColor(),
      unselectedItemColor: widget.general.enableShowTitlesAlwaysForBottomMenu == false ? null : widget.general.getHeaderItemsColor(),
      unselectedIconTheme: IconThemeData(color: widget.general.getHeaderItemsColor()),
      selectedIconTheme: IconThemeData(color: widget.general.getHeaderSelectedItemsColor()),
      fixedColor: widget.general.enableShowTitlesAlwaysForBottomMenu == true ? null : widget.general.getHeaderItemsColor(),
      currentIndex: _selectedIndex,
      selectedLabelStyle: widget.general.enableShowTitlesAlwaysForBottomMenu == false
          ? null
          : getFontStyle(13, widget.general.getHeaderSelectedItemsColor(), FontWeight.normal, widget.general),
      unselectedLabelStyle: widget.general.enableShowTitlesAlwaysForBottomMenu == false
          ? null
          : getFontStyle(13, widget.general.getHeaderItemsColor(), FontWeight.normal, widget.general),
      onTap: _onItemTapped,
    );
  }

  List<BottomNavigationBarItem> classicNavItems() {
    if (widget.appOptions.navItems.isNotEmpty) {
      List<BottomNavigationBarItem> items = List.generate(widget.appOptions.navItems.length, (index) {
        return BottomNavigationBarItem(
            label: widget.appOptions.navItems[index].getLocalizedTitle(),
            backgroundColor: widget.general.getHeaderColor(),
            activeIcon: FaIcon(
              widget.appOptions.navItems[index].getSideItemIcon(),
              color: widget.general.getHeaderSelectedItemsColor(),
              size: 18,
            ),
            icon: FaIcon(
              widget.appOptions.navItems[index].getSideItemIcon(),
              color: widget.general.getHeaderItemsColor(),
              size: 18,
            ));
      });
      return items;
    } else {
      List<BottomNavigationBarItem> items = [];
      return items;
    }
  }

  Widget mainWidget() {
    return adShow
        ? Column(
            children: [
              Expanded(child: setSelectedWidget(item)),
              Container(
                color: widget.general.getHeaderColor(),
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                alignment: Alignment.center,
                child: Align(alignment: Alignment.centerLeft, child: AdWidget(ad: _ad)),
              ),
            ],
          )
        : setSelectedWidget(item);
  }

  List<GButton> navItems() {
    if (widget.appOptions.navItems.isNotEmpty) {
      List<GButton> items = List.generate(widget.appOptions.navItems.length, (index) {
        return GButton(
          textColor: widget.general.getHeaderSelectedItemsColor(),
          hoverColor: widget.general.getHeaderItemsColor(),
          iconActiveColor: widget.general.getHeaderSelectedItemsColor(),
          backgroundColor: widget.general.getHeaderColor(),
          activeBorder: Border.all(color: widget.general.getHeaderSelectedItemsColor()),
          iconColor: widget.general.getHeaderItemsColor(),
          icon: widget.appOptions.navItems[index].getSideItemIcon(),
          text: widget.appOptions.navItems[index].getLocalizedTitle(),
          textStyle: getFontStyle(13, widget.general.getHeaderSelectedItemsColor(), FontWeight.normal, widget.general),
        );
      });
      return items;
    } else {
      List<GButton> items = [];
      return items;
    }
  }

  List<Bubble> floatingItems() {
    if (widget.appOptions.floatingItems.isNotEmpty) {
      List<Bubble> items = List.generate(widget.appOptions.floatingItems.length, (index) {
        SideItem curentItem = widget.appOptions.floatingItems[index];
        return Bubble(
          title: curentItem.getLocalizedTitle(),
          iconColor: widget.general.getFloatingIconColor(),
          bubbleColor: widget.general.getFloatingMenuColor(),
          icon: curentItem.getSideItemIcon(),
          titleStyle: getFontStyle(15, widget.general.getFloatingIconColor(), FontWeight.normal, widget.general),
          onPress: () {
            _animationController.reverse();
            if (mounted) {
              if (item.type == ItemType.social) {
                launchUrl(Uri.parse(item.link));
              } else if (item.type == ItemType.phone) {
                String phone = "tel://${item.text}";
                launchUrl(Uri.parse(phone));
              }
              setState(() {
                previousItem = item;
                item = curentItem;
                if (item.type != ItemType.rateUs) {
                  title = item.title;
                }
              });
            }
          },
        );
      });
      return items;
    } else {
      List<Bubble> items = [];
      return items;
    }
  }

  void checkForLoad(SideItem item) async {
    if (item.type == ItemType.home) {
      if (widget.general.mainURL.isNotEmpty) {
        await webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(widget.general.mainURL)));
      }
      return;
    }
    Uri? url = await webViewController?.getUrl();
    if (url != null) {
      if (item.link.isNotEmpty && item.link != url.toString()) {
        isInitialLoaded = false;
        await webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(item.link)));
      }
    }
  }

  Widget setSelectedWidget(SideItem item) {
    showInterstitial();
    if (item.type == ItemType.home) {
      checkForLoad(item);
      return Stack(
        children: [
          BeWebView(
              url: Uri.encodeFull(widget.general.mainURL),
              general: widget.general,
              callback: (webView) {
                webViewController = webView;
              },
              onPageFinish: (height) {
                if (mounted) {
                  setState(() {
                    webViewHeight = height;
                  });
                }
              },
              options: widget.appOptions),
          //isLoading ? const Loading() : Stack(),
        ],
      );
    } else if (item.type == ItemType.link) {
      checkForLoad(item);
      return BeWebView(
          url: Uri.encodeFull(item.link),
          general: widget.general,
          item: item,
          callback: (webView) {
            webViewController = webView;
          },
          onPageFinish: () {},
          options: widget.appOptions);
    } else if (item.type == ItemType.text) {
      return TextComponent(item: item);
    } else if (item.type == ItemType.profile) {
      return SettingsScreen(general: widget.general, options: widget.appOptions);
    } else if (item.type == ItemType.chat) {
      return ChatScreen(
        general: widget.general,
        options: widget.appOptions,
      );
    } else if (item.type == ItemType.googleMaps) {
      return LocationComponent(
        item: item,
        options: widget.appOptions,
        general: widget.general,
      );
    } else if (item.type == ItemType.aboutUs) {
      return AboutUsScreen(
        item: item,
        general: widget.general,
      );
    } else if (item.type == ItemType.youTubeVideos) {
      return YouTubeVideos(
        item: item,
        general: widget.general,
      );
    } else if (item.type == ItemType.wordpress) {
      return WPPostsScreen(
        general: widget.general,
        item: item,
      );
    } else if (item.type == ItemType.gallery) {
      return GalleryScreen(
        options: widget.appOptions,
        general: widget.general,
      );
    } else if (item.type == ItemType.qrCode) {
      return QRCodeScreen(
        options: widget.appOptions,
        general: widget.general,
      );
    } else if (item.type == ItemType.languages) {
      return SelectLanguageScreen(
        model: BeAppModel(options: widget.appOptions, general: widget.general),
        onLanguageSelected: (Localization localization) {
          setState(() {
            widget.appOptions.localization = localization;
            widget.general.enableRTL = isRTL;
          });
        },
      );
    } else if (item.type == ItemType.wooProducts) {
      BeAppModel appModel = BeAppModel(options: widget.appOptions, general: widget.general);
      appModel.wooConfig = widget.wooConfig;

      WooProductsScreen wooScreen = WooProductsScreen(
          key: _wooKey,
          model: appModel,
          onProductBack: () {
            SideItem wooItem = SideItem(title: "woo");
            wooItem.type == ItemType.wooProducts;
            if (mounted) {
              setState(() {
                item = wooItem;
              });
            }
          },
          tagID: item.tagID,
          categoryID: item.categoryID);
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ProductProvider(),
            child: wooScreen,
          )
        ],
        child: wooScreen,
      );
    } else if (item.type == ItemType.sideScreen) {
      return SideScreen(
        general: widget.general,
        appOptions: widget.appOptions,
        onItemClick: (SideItem selectedItem) {
          if (mounted) {
            setState(() {
              previousItem = item;
              this.item = selectedItem;
              if (item.type != ItemType.rateUs) {
                title = item.title;
              }
            });
          }
        },
        item: item,
      );
    } else if (item.type == ItemType.videos) {
      return VideoScreen(
        general: widget.general,
      );
    } else if (item.type == ItemType.radioStreams) {
      return RadioStream(
        item: item,
        general: widget.general,
      );
    } else if (item.type == ItemType.feedback) {
      return FeedbackComponent(
        item: item,
        general: widget.general,
      );
    } else if (item.type == ItemType.rateUs) {
      if (widget.general.enabledAnalytics) {
        APIService().logEvent(AnalyticsType.userRates);
      }
      inAppReview.openStoreListing(
        appStoreId: widget.general.rateAppleStoreID,
      );
      item = previousItem;
      return BeWebView(
        url: Uri.encodeFull(widget.general.mainURL),
        general: widget.general,
        callback: (webView) {
          webViewController = webView;
        },
        onPageFinish: (height) {
          if (mounted) {
            setState(() {
              webViewHeight = height;
            });
          }
        },
        options: widget.appOptions,
      );
    } else {
      if (item.type == ItemType.social) {
        launchUrl(Uri.parse(item.link));
      } else if (item.type == ItemType.phone) {
        String phone = "tel://${item.text}";
        launchUrl(Uri.parse(phone));
      } else if (item.type == ItemType.signOut) {
        signOutAction();
      }
      checkForLoad(item);
      return BeWebView(
        url: Uri.encodeFull(widget.general.mainURL),
        general: widget.general,
        callback: (webView) {
          webViewController = webView;
        },
        onPageFinish: (height) {
          if (mounted) {
            setState(() {
              webViewHeight = height;
            });
          }
        },
        options: widget.appOptions,
      );
    }
  }

  showInterstitial() {
    if (widget.general.enabledAdmob) {
      adCounter++;
      if (adCounter >= adClicks) {
        admobService.showInterstitialAd();
        adCounter = 0;
      }
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (mounted) {
      if (widget.general.blockVPNUsers) {
        checkVPNConnection();
      }
      setState(() {
        _connectionStatus = result;
      });
    }
  }

  showWelcomePopup() async {
    if (widget.appOptions.popup.showAlways == false) {
      bool isShown = await MySharedPreferences.instance.getBooleanValue("WelcomePopupShown");
      if (isShown) {
        return;
      }
    }
    if (widget.appOptions.popup.isEnabled) {
      await Future.delayed(const Duration(milliseconds: 50));
      await showDialog(
          context: context,
          builder: (_) => PopupWidget(
                popup: widget.appOptions.popup,
                options: widget.appOptions,
                general: widget.general,
              ));
      MySharedPreferences.instance.setBooleanValue("WelcomePopupShown", true);
    }
  }

  void signOutAction() async {
    await AuthService().signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(model: BeAppModel(options: widget.appOptions, general: widget.general))),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
            context: context,
            builder: (_) => Dialog(
                  // backgroundColor: Colors.transparent,
                  // elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20, left: 10, right: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 170,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          mainLocalization.localization.exitMessageTitle,
                          style: getFontStyle(20, Colors.black, FontWeight.bold, widget.general),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          mainLocalization.localization.exitMessageSubtitle,
                          textAlign: TextAlign.center,
                          style: getFontStyle(18, Colors.black, FontWeight.normal, widget.general),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BeButton(
                              name: mainLocalization.localization.noButton,
                              callback: () {
                                Navigator.of(context).pop(false);
                              },
                              general: widget.general,
                            ),
                            BeButton(
                                name: mainLocalization.localization.yesButton,
                                callback: () {
                                  Navigator.of(context).pop(true);
                                },
                                general: widget.general),
                          ],
                        ),
                      ],
                    ),
                  ),
                )) ??
        false;
  }
}

class BeWebView extends StatefulWidget {
  const BeWebView(
      {Key? key, required this.url, required this.general, this.item, required this.callback, required this.onPageFinish, required this.options})
      : super(key: key);
  final General general;
  final String url;
  final SideItem? item;
  final Function callback;
  final Function onPageFinish;
  final AppOptions options;

  @override
  State<BeWebView> createState() => _BeWebViewState();
}

class _BeWebViewState extends State<BeWebView> {
  InAppWebViewController? webViewController;

  final GlobalKey webViewKey = GlobalKey();
  late PullToRefreshController pullToRefreshController;
  String url = "";
  String cookiesString = '';
  double progress = 0;
  final urlController = TextEditingController();
  bool errorFound = false;
  bool isLoading = true;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions();
  String token = "";
  SocialHelper socialHelper = SocialHelper();
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    // TODO: implement initState
    if (!widget.general.enableLoadingWebView) {
      isLoading = false;
    }
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) async {
      sleep(const Duration(milliseconds: 300));
      webViewController?.android.pageDown(bottom: true);
    });

    options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          userAgent: widget.general.customUserAgent ? widget.general.customUserAgentString : "",
          supportZoom: widget.general.enablePinchZoom,
          useShouldOverrideUrlLoading: true,
          clearCache: !widget.general.enableCookies,
          mediaPlaybackRequiresUserGesture: false,
          transparentBackground: true,
          javaScriptEnabled: true,
          disableHorizontalScroll: !widget.general.enableHorizontalScroll,
          javaScriptCanOpenWindowsAutomatically: true,
          verticalScrollBarEnabled: false,
          horizontalScrollBarEnabled: false,
          useOnDownloadStart: true,
        ),
        android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
            allowFileAccess: true,
            allowContentAccess: true,
            supportMultipleWindows: widget.general.enableMultiWindow,
            clearSessionCache: !widget.general.enableCookies,
            thirdPartyCookiesEnabled: widget.general.enableCookies),
        ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
            sharedCookiesEnabled: widget.general.enableCookies,
            alwaysBounceVertical: true,
            disallowOverScroll: false));

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: widget.general.getTopNavigationItemColor(), backgroundColor: widget.general.getTopNavigationColor()),
      onRefresh: () async {
        if (UniversalPlatform.isAndroid) {
          webViewController?.reload();
        } else if (UniversalPlatform.isIOS) {
          await webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Future<void> updateCookies(Uri url) async {
    List<Cookie> cookies = await CookieManager.instance().getCookies(url: url);

    String cook = "";
    for (Cookie cookie in cookies) {
      cook += '${cookie.name}=${cookie.value};';
      if (cookie.name.startsWith("remember_web")) {
        token = cookie.value;
      }
    }
    if (cook.isNotEmpty) {
      cookiesString = "";
      cookiesString = cook;
    }
  }

  @override
  Widget build(BuildContext context) {
    return errorFound == false
        ? webView()
        : ErrorPage(
            onRefreshClick: () {
              webViewController?.reload();
              if (mounted) {
                setState(() {
                  errorFound = false;
                });
              }
            },
            onGoHomeClick: () {
              webViewController?.goBack();
              if (mounted) {
                setState(() {
                  errorFound = false;
                });
              }
            },
            general: widget.general,
            options: widget.options,
          );
  }

  Widget webView() {
    return Stack(
      children: [
        Container(
          color: widget.general.getTopNavigationColor(),
          child: InAppWebView(
            key: webViewKey,
            initialOptions: options,
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            pullToRefreshController: widget.general.pullDownToRefresh ? pullToRefreshController : null,
            onWebViewCreated: (controller) {
              webViewController = controller;
              widget.callback(webViewController);
            },
            onCloseWindow: (controller) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            onConsoleMessage: (controller, message) {
              print("Console Message");
              print(message.message);
            },
            onCreateWindow: (controller, createWindowRequest) async {
              showBarModalBottomSheet(
                  expand: true,
                  enableDrag: false,
                  context: context,
                  elevation: 1,
                  topControl: Container(
                      color: Colors.black,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                  builder: (context) {
                    return SafeArea(
                      child: Container(
                        color: widget.general.getTopNavigationColor(),
                        child: InAppWebView(
                          // Setting the windowId property is important here!
                          windowId: createWindowRequest.windowId,
                          initialUrlRequest: createWindowRequest.request,
                          initialOptions: options,
                          androidOnPermissionRequest: (controller, origin, resources) async {
                            return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                          },
                          onWebViewCreated: (InAppWebViewController controller) {},
                          onLoadStart: (controller, url) {
                            debugPrint('secondary load start');
                          },
                          shouldOverrideUrlLoading: (controller, navigationAction) async {
                            var uri = navigationAction.request.url!;
                            debugPrint(uri.toString());
                            if (uri.toString().endsWith(".pdf")) {
                              if (UniversalPlatform.isIOS) {
                                await launchUrl(Uri.parse(uri.toString()), mode: LaunchMode.externalApplication);
                              }
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (uri.toString().startsWith("whatsapp:") ||
                                uri.toString().startsWith("fb:") ||
                                uri.toString().startsWith("viber:") ||
                                uri.toString().startsWith("twitter:") ||
                                uri.toString().startsWith("mailto:") ||
                                uri.toString().startsWith("tel:") ||
                                uri.toString().startsWith("youtube:") ||
                                uri.toString().startsWith("snapchat:") ||
                                uri.toString().startsWith("tiktok:") ||
                                uri.toString().startsWith("telegram:") ||
                                uri.toString().startsWith("linkedin:") ||
                                uri.toString().startsWith("instagram:")) {
                              launchUrl(Uri.parse(uri.toString()), mode: LaunchMode.externalApplication);
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (socialHelper.isSocial(uri.toString())) {
                              String link = socialHelper.getSocialMobileLink(uri.toString());
                              debugPrint("Mobile Friendly Link");
                              debugPrint(link);
                              if (await canLaunchUrl(Uri.parse(link))) {
                                launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                              }
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                              if (await canLaunchUrl(Uri.parse(url))) {
                                // Launch the App
                                await launchUrl(
                                  Uri.parse(url),
                                );
                                // and cancel the request
                                return NavigationActionPolicy.CANCEL;
                              }
                            }

                            return NavigationActionPolicy.ALLOW;
                          },
                          onDownloadStartRequest: (controller, request) async {
                            debugPrint("DOWNLOADING START2");

                            String filename = request.suggestedFilename?.replaceAll(" ", "_") ?? "default.pdf";
                            if (await Permission.storage.request().isGranted) {
                              FlutterDownloader.registerCallback(callback);
                              await FlutterDownloader.enqueue(
                                url: Uri.encodeFull(request.url.toString()).toString(),
                                fileName: filename,
                                headers: {
                                  HttpHeaders.cookieHeader: cookiesString,
                                },
                                savedDir: (await getExternalStorageDirectory())!.path,
                                saveInPublicStorage: true,
                                showNotification: true, // show download progress in status bar (for Android)
                                openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                              );
                            }
                          },
                          onLoadStop: (controller, url) {},
                        ),
                      ),
                    );
                  });

              return true;
            },
            androidOnGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async {
              return GeolocationPermissionShowPromptResponse(origin: origin, allow: true, retain: true);
            },
            onDownloadStartRequest: (controller, request) async {
              String filename = request.suggestedFilename ?? "";
              if (await Permission.storage.request().isGranted) {
                FlutterDownloader.registerCallback(callback);
                await FlutterDownloader.enqueue(
                  url: Uri.encodeFull(request.url.toString()).toString(),
                  fileName: filename,
                  headers: {HttpHeaders.cookieHeader: cookiesString},
                  savedDir: (await getExternalStorageDirectory())!.path,
                  saveInPublicStorage: true,
                  showNotification: true, // show download progress in status bar (for Android)
                  openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                );
              }
            },
            onLoadStart: (controller, url) {
              if (mounted) {
                setState(() {
                  if (widget.general.enableLoadingWebView) {
                    isLoading = true;
                  }
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              }
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              debugPrint(uri.toString());
              if (uri.toString().endsWith(".pdf")) {
                if (UniversalPlatform.isIOS) {
                  await launchUrl(Uri.parse(uri.toString()), mode: LaunchMode.externalApplication);
                }
                return NavigationActionPolicy.CANCEL;
              }
              if (uri.toString().startsWith("whatsapp:") ||
                  uri.toString().startsWith("fb:") ||
                  uri.toString().startsWith("viber:") ||
                  uri.toString().startsWith("twitter:") ||
                  uri.toString().startsWith("mailto:") ||
                  uri.toString().startsWith("tel:") ||
                  uri.toString().startsWith("youtube:") ||
                  uri.toString().startsWith("snapchat:") ||
                  uri.toString().startsWith("tiktok:") ||
                  uri.toString().startsWith("telegram:") ||
                  uri.toString().startsWith("linkedin:") ||
                  uri.toString().startsWith("instagram:")) {
                launchUrl(Uri.parse(uri.toString()), mode: LaunchMode.externalApplication);
                return NavigationActionPolicy.CANCEL;
              }
              if (socialHelper.isSocial(uri.toString())) {
                String link = socialHelper.getSocialMobileLink(uri.toString());
                if (await canLaunchUrl(Uri.parse(link))) {
                  launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                }
                return NavigationActionPolicy.CANCEL;
              }
              if (uri.toString().contains("#googtrans")) {
                webViewController?.reload();
              }
              if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                if (await canLaunchUrl(Uri.parse(url))) {
                  // Launch the App
                  await launchUrl(
                    Uri.parse(url),
                  );
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
            onAjaxProgress: (controller, ajaxRequest) async {
              debugPrint("AjaxProgress");
              return AjaxRequestAction.PROCEED;
            },
            onAjaxReadyStateChange: (controller, ajaxRequest) async {
              debugPrint("AjaxReadyState");
              return AjaxRequestAction.PROCEED;
            },
            onJsAlert: (controller, jsAlertRequest) async {
              if (widget.general.enableToastOnJsAlerts) {
                Fluttertoast.showToast(
                    msg: jsAlertRequest.message ?? "Alert message is empty",
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: widget.general.getHeaderColor(),
                    textColor: widget.general.getHeaderItemsColor(),
                    fontSize: 16.0);
                JsAlertResponseAction action = JsAlertResponseAction.CONFIRM;
                return JsAlertResponse(handledByClient: true, action: action);
              } else {
                JsAlertResponseAction action = JsAlertResponseAction.CONFIRM;
                return JsAlertResponse(handledByClient: false, action: action);
              }
            },
            onLoadStop: (controller, url) async {
              debugPrint(url.toString());
              if (url != null) {
                await updateCookies(url);
              }
              pullToRefreshController.endRefreshing();
              if (widget.item != null) {
                if (widget.item!.type == ItemType.home && widget.general.enableCustomJavascript) {
                  widget.item!.customJS = widget.general.customJavascriptCode;
                }
                if (widget.item!.customJS.isNotEmpty && webViewController != null) {
                  await controller.evaluateJavascript(source: widget.item!.customJS);
                }
              } else {
                if (widget.general.enableCustomJavascript) {
                  await controller.evaluateJavascript(source: widget.general.customJavascriptCode);
                }
              }
              if (mounted) {
                setState(() {
                  isLoading = false;
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              }
            },
            onLoadError: (controller, url, code, message) {
              if (code == -999) {
              } else {
                if (mounted) {
                  setState(() {
                    errorFound = true;
                  });
                }
                pullToRefreshController.endRefreshing();
              }
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                pullToRefreshController.endRefreshing();
              }
              if (mounted) {
                setState(() {
                  this.progress = 0;
                  urlController.text = url;
                });
              }
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              if (mounted) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              }
            },
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Loading(general: widget.general),
        )
      ],
    );
  }

  static void callback(String id, DownloadTaskStatus status, int progress) {
    debugPrint(id);
    debugPrint(status.value.toString());
    debugPrint(progress.toString());
  }
}
