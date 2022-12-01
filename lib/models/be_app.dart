import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/models/woo_config.dart';

class BeAppModel {
  AppOptions options;
  General general;
  WooConfig? wooConfig;
  bool isLanguageSelected = true;
  BeAppModel({required this.options, required this.general});
}
