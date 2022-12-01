import 'package:be_app_mobile/widgets/be_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/font_helper.dart';
import '../models/app_options.dart';
import '../models/general.dart';
import '../screens/items/woo_commerce/woo_globals.dart';

class PermissionsWidget extends StatefulWidget {
  const PermissionsWidget({Key? key, required this.options, required this.general}) : super(key: key);

  final AppOptions options;
  final General general;

  @override
  State<PermissionsWidget> createState() => _PermissionsWidgetState();
}

class _PermissionsWidgetState extends State<PermissionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.general.getApplicationColor(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Image(
                  image: AssetImage('images/microphone.png'),
                  width: 100,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 10,
                ),
                Image(
                  image: AssetImage('images/camera.png'),
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                mainLocalization.localization.permissionsTitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getFontStyle(22, Colors.black87, FontWeight.bold, widget.general),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  mainLocalization.localization.permissions,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: getFontStyle(18, Colors.black54, FontWeight.normal, widget.general),
                ),
              ),
            ),
            BeButton(
                name: "Allow Access",
                callback: () {
                  askForPermissions();
                },
                general: widget.general),
            const SizedBox(
              height: 15,
            ),
            BeButton(
                name: "Don't Allow Access",
                callback: () {
                  Navigator.of(context).pop();
                },
                general: widget.general)
          ],
        ),
      ),
    );
  }

  void askForPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    Navigator.of(context).pop();
  }
}
