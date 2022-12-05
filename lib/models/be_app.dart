import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/general.dart';

class BeAppModel {
  AppOptions options;
  General general;
  bool isLanguageSelected = true;
  BeAppModel({required this.options, required this.general});
}
