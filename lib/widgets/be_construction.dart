import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/material.dart';

import '../models/app_options.dart';

class BeConstruction extends StatelessWidget {
  const BeConstruction({Key? key, required this.options, required this.general}) : super(key: key);
  final AppOptions options;
  final General general;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage(
                  "images/construction.png",
                ),
                width: 300,
                height: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                mainLocalization.localization.weAreUnderMaintenance,
                textAlign: TextAlign.center,
                style: getFontStyle(25, Colors.black, FontWeight.bold, general),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                mainLocalization.localization.ourAppIsInMaintenance,
                textAlign: TextAlign.center,
                style: getFontStyle(20, Colors.grey, FontWeight.normal, general),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                mainLocalization.localization.weWillBeBackShortly,
                style: getFontStyle(20, Colors.grey, FontWeight.normal, general),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
