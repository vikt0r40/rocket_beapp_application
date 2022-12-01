import 'package:app_settings/app_settings.dart';
import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/general.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key, required this.options, required this.general}) : super(key: key);
  final AppOptions options;
  final General general;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: general.getHeaderColor(),
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const FaIcon(
                FontAwesomeIcons.wifi,
                color: Colors.redAccent,
                size: 30,
              ),
              Expanded(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      mainLocalization.localization.slowConnection,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: getFontStyle(16, general.getHeaderItemsColor(), FontWeight.normal, general),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppSettings.openWirelessSettings();
                },
                child: FaIcon(
                  FontAwesomeIcons.gear,
                  size: 30,
                  color: general.getHeaderItemsColor(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
