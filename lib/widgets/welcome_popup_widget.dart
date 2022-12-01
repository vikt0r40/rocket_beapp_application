import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/models/welcome_popup.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:flutter/material.dart';

import 'be_button.dart';

class PopupWidget extends StatelessWidget {
  const PopupWidget({Key? key, required this.popup, required this.options, required this.general}) : super(key: key);
  final WelcomePopup popup;
  final AppOptions options;
  final General general;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 20, left: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 200,
              child: BeImage(
                link: options.popup.imageUrl,
                width: 220,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              popup.title,
              style: getFontStyle(20, Colors.black, FontWeight.bold, general),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              popup.text,
              textAlign: TextAlign.center,
              style: getFontStyle(18, Colors.black, FontWeight.normal, general),
            ),
            const SizedBox(
              height: 40,
            ),
            BeButton(
              name: mainLocalization.localization.gotItThankYou,
              callback: () {
                Navigator.of(context).pop();
              },
              general: general,
            ),
          ],
        ),
      ),
    );
  }
}
