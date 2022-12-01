import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/models/side_item.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key, req, required this.item, required this.general}) : super(key: key);
  final SideItem item;
  final General general;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              BeImage(
                link: general.logoUrl,
                width: 250,
                height: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              socialIcons(),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: HTML.toTextSpan(context, item.text),
              ),
              //BeHtmlText(htmlText: item.text),
              // Html(
              //   data: item.text,
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget socialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Visibility(
            visible: general.social.facebook.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.facebook);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.facebook, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.instagram.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.instagram);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.instagram, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.twitter.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.twitter);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.twitter, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.pinterest.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.pinterest);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.pinterest, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.linkedin.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.linkedin);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.tiktok.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.tiktok);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.tiktok, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.youtube.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.youtube);
              },
              child: const SizedBox(
                width: 40,
                height: 50,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.youtube, color: Colors.black),
                ),
              ),
            )),
        Visibility(
            visible: general.social.vimeo.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                lunchUrl(general.social.vimeo);
              },
              child: const SizedBox(
                width: 15,
                height: 40,
                child: FaIcon(
                  FontAwesomeIcons.vimeo,
                  color: Colors.black,
                ),
              ),
            )),
      ],
    );
  }

  void lunchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }
}
