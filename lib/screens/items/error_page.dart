import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/widgets/be_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/general.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.onRefreshClick, required this.onGoHomeClick, required this.general, required this.options})
      : super(key: key);

  final Function onRefreshClick;
  final Function onGoHomeClick;
  final General general;
  final AppOptions options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: general.getTopNavigationColor(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.cloudBolt,
              color: general.getTopNavigationItemColor(),
              size: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                mainLocalization.localization.pageErrorTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: getFontStyle(19, general.getTopNavigationItemColor(), FontWeight.normal, general),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BeButton(
                    name: mainLocalization.localization.pageErrorButtonBack,
                    callback: () {
                      onGoHomeClick();
                    },
                    whiteMode: true,
                    general: general,
                  ),
                  BeButton(
                    name: mainLocalization.localization.pageErrorButtonRefresh,
                    callback: () {
                      onRefreshClick();
                    },
                    whiteMode: true,
                    general: general,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
