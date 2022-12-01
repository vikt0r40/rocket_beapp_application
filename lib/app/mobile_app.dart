import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/woo_config.dart';
import 'package:be_app_mobile/offline_settings.dart';
import 'package:be_app_mobile/widgets/be_construction.dart';
import 'package:be_app_mobile/widgets/demo_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/app_options.dart';
import '../models/general.dart';
import '../screens/home_screen.dart';
import '../widgets/loading.dart';

class BeApp extends StatefulWidget {
  const BeApp({Key? key, required this.beAppModel}) : super(key: key);
  final BeAppModel beAppModel;
  @override
  State<BeApp> createState() => _BeAppState();
}

class _BeAppState extends State<BeApp> {
  bool refresh = true;
  OfflineSettings settings = OfflineSettings();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.beAppModel.general.enabledAdmob) {
      MobileAds.instance.initialize();
    }
    if (widget.beAppModel.general.enableScreenSecurity) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return releaseApp();
  }

  Widget releaseApp() {
    return widget.beAppModel.general.instantUpdates
        ? appWithInstantUpdates()
        : MobileScreen(
            general: widget.beAppModel.general,
            appOptions: widget.beAppModel.options,
            wooConfig: widget.beAppModel.wooConfig ?? WooConfig(),
          );
  }

  Widget demoApp() {
    return DemoWidget(model: widget.beAppModel);
  }

  Widget appWithInstantUpdates() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("settings").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active && !snapshot.hasError) {
          General general = General();
          AppOptions options = AppOptions();
          for (QueryDocumentSnapshot documentSnapshot in snapshot.data?.docs ?? []) {
            if (documentSnapshot.id == "general") {
              general = General.fromJson(documentSnapshot.data() as Map<dynamic, dynamic>);
            }
            if (documentSnapshot.id == "options") {
              options = AppOptions.fromJson(documentSnapshot.data() as Map<dynamic, dynamic>);
            }
          }
          if (general.enableConstructionMode) {
            return BeConstruction(
              options: options,
              general: widget.beAppModel.general,
            );
          }
          if (refresh) {
            refresh = false;
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() {});
              }
            });
            return Loading(
              general: widget.beAppModel.general,
            );
          }
          return MobileScreen(
            general: general,
            appOptions: options,
            wooConfig: widget.beAppModel.wooConfig ?? WooConfig(),
          );
        } else {
          return Loading(
            general: widget.beAppModel.general,
          );
        }
      },
    );
  }
}
