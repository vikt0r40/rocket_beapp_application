import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/widgets/be_button.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/app_options.dart';
import '../models/general.dart';

class VPNRestrictionScreen extends StatelessWidget {
  const VPNRestrictionScreen({Key? key, required this.options, required this.general}) : super(key: key);
  final AppOptions options;
  final General general;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 237, 242, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.shield,
                size: 250,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                mainLocalization.localization.vpnTitle,
                textAlign: TextAlign.center,
                style: getFontStyle(25, Colors.black, FontWeight.bold, general),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                mainLocalization.localization.vpnSubtitle,
                textAlign: TextAlign.center,
                style: getFontStyle(20, Colors.grey, FontWeight.normal, general),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                mainLocalization.localization.vpnThirdTitle,
                style: getFontStyle(20, Colors.grey, FontWeight.normal, general),
              ),
              const SizedBox(
                height: 20,
              ),
              BeButton(
                  name: mainLocalization.localization.tryAgain,
                  callback: () async {
                    if (await CheckVpnConnection.isVpnActive() == false) {
                      Navigator.of(context).pop();
                    }
                  },
                  general: general)
            ],
          ),
        ),
      ),
    );
  }
}
