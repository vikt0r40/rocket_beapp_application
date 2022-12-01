import 'dart:ui';

import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../autorization/pages/login_page.dart';
import '../autorization/service/auth_service.dart';
import '../models/be_app.dart';
import '../models/general.dart';
import '../models/side_item.dart';
import '../service/api_service.dart';

class SideScreen extends StatefulWidget {
  final Function(SideItem)? onItemClick;
  final General general;
  final AppOptions appOptions;
  final SideItem? item;
  const SideScreen({Key? key, this.onItemClick, required this.general, required this.appOptions, this.item}) : super(key: key);

  @override
  State<SideScreen> createState() => _SideScreenState();
}

class _SideScreenState extends State<SideScreen> {
  int selectedIndex = 0;
  APIService service = APIService();
  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Directionality(textDirection: TextDirection.rtl, child: mainWidget())
        ],
      );
    } else {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          mainWidget(),
        ],
      );
    }
  }

  Widget mainWidget() {
    if (widget.general.social.hasSocial()) {
      return Scaffold(
        backgroundColor: widget.general.getSideMenuColor(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: sideMenuItems(),
                ),
              ),
            ),
            enableFooter()
                ? SizedBox(
                    height: 120,
                    child: footer(),
                  )
                : Container()
          ],
        ),
      );
    } else {
      return ListView(
        padding: EdgeInsets.zero,
        children: sideMenuItems(),
      );
    }
  }

  bool enableFooter() {
    if (widget.item != null) {
      return widget.item!.enableFooter;
    } else {
      return true;
    }
  }

  List<Widget> sideMenuItems() {
    List<Widget> items = List.generate(widget.appOptions.sideItems.length, (index) {
      return ListTile(
        iconColor: widget.general.getSideMenuItemColor(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              child: FaIcon(
                widget.appOptions.sideItems[index].getSideItemIcon(),
                size: 16,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.appOptions.sideItems[index].getLocalizedTitle(),
              maxLines: 3,
              textAlign: TextAlign.left,
              style: getFontStyle(16, widget.general.getSideMenuItemColor(), FontWeight.w600, widget.general),
            )
          ],
        ),
        tileColor: widget.general.getSideMenuColor(),
        onTap: () {
          if (widget.appOptions.sideItems[index].type == ItemType.social) {
            lunchUrl(widget.appOptions.sideItems[index].link);
            return;
          } else if (widget.appOptions.sideItems[index].type == ItemType.phone) {
            String phone = "tel://${widget.appOptions.sideItems[index].text}";
            launchUrl(Uri.parse(phone));
            return;
          }
          widget.onItemClick!(widget.appOptions.sideItems[index]);
          setState(() {
            selectedIndex = index;
          });
          if (widget.item == null) {
            Navigator.pop(context);
          }
        },
      );
    });
    DrawerHeader header = DrawerHeader(
      decoration: BoxDecoration(
        color: widget.general.getSideMenuColor(),
      ),
      child: widget.general.logoUrl == ""
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BeImage(
                  link: widget.general.logoUrl,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.general.sideScreenTitle,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    style: getFontStyle(16, widget.general.getSideMenuItemColor(), FontWeight.w600, widget.general),
                  ),
                )
              ],
            ),
    );
    if (widget.item != null) {
      if (widget.item!.enableLogoAndTitle) {
        items.insert(0, header);
      }
    } else {
      items.insert(0, header);
    }

    return items;
  }

  Widget footer() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                  visible: widget.general.enableShareInSideMenu,
                  child: GestureDetector(
                    onTap: () {
                      Share.share(widget.general.shareMsg);
                      if (widget.general.enabledAnalytics) {
                        APIService().logEvent(AnalyticsType.userShares);
                      }
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.share,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.facebook.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.facebook);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.instagram.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.instagram);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.instagram,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.twitter.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.twitter);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.twitter,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.pinterest.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.pinterest);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.pinterest,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.linkedin.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.linkedin);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.tiktok.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.tiktok);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.tiktok,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.youtube.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.youtube);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.youtube,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
              Visibility(
                  visible: widget.general.social.vimeo.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      lunchUrl(widget.general.social.vimeo);
                    },
                    child: SizedBox(
                      width: 30,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FaIcon(
                          FontAwesomeIcons.vimeo,
                          color: widget.general.getSideMenuItemColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void lunchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }

  void signOutAction() async {
    await AuthService().signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(model: BeAppModel(options: widget.appOptions, general: widget.general))),
    );
  }
}

class Data {
  MaterialColor color;
  String name;
  String detail;

  Data(this.color, this.name, this.detail);
}

class ColoursHelper {
  static Color blue() => const Color(0xff5e6ceb);

  static Color blueDark() => const Color(0xff4D5DFB);
}
