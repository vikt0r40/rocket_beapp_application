import 'package:be_app_mobile/app/splash_app.dart';
import 'package:be_app_mobile/autorization/pages/login_page.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/be_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key, required this.model}) : super(key: key);
  final BeAppModel model;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BeUser?>(context);
    if (user == null) {
      FlutterNativeSplash.remove();
      return LoginPage(model: model);
    } else {
      return SplashApp(beApp: model);
    }
  }
}
