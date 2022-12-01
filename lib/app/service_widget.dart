import 'package:be_app_mobile/app/starter_app.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/be_app.dart';
import '../models/general.dart';
import '../offline_settings.dart';
import '../service/api_service.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget({Key? key}) : super(key: key);

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  final OfflineSettings settings = OfflineSettings();

  @override
  Widget build(BuildContext context) {
    if (settings.enableOfflineMode) {
      BeAppModel beAppModel = BeAppModel(options: settings.getApplicationSettings(), general: settings.getGeneralSettings());
      beAppModel.general.enableAuthorization = false;
      return StarterApp(model: beAppModel);
    }
    return FutureBuilder(
        future: APIService().getAppConfiguration(),
        builder: (BuildContext context, AsyncSnapshot<BeAppModel> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.lightBlue,
            );
          } else {
            BeAppModel beAppModel = snapshot.data ?? BeAppModel(options: AppOptions(), general: General());

            if (beAppModel.general.enableLandscape) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ]);
            } else {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            }
            return StarterApp(model: beAppModel);
          }
        });
  }
}
