import 'package:be_app_mobile/app/splash_app.dart';
import 'package:be_app_mobile/autorization/wrapper/auth_wrapper.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/be_user.dart';
import 'package:be_app_mobile/offline_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../autorization/service/auth_service.dart';

class StarterApp extends StatelessWidget {
  StarterApp({Key? key, required this.model}) : super(key: key);
  final BeAppModel model;
  final OfflineSettings settings = OfflineSettings();

  @override
  Widget build(BuildContext context) {
    return getStartingWidget(model);
  }

  Widget getStartingWidget(BeAppModel model) {
    if (model.general.enableAuthorization) {
      return StreamProvider<BeUser?>.value(
          initialData: BeUser(uid: "", displayName: "", email: ""), value: AuthService().user, child: AuthWrapper(model: model));
    } else {
      return SplashApp(beApp: model);
    }
  }
}
