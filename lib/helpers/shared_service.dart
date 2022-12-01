import 'dart:convert';

import 'package:be_app_mobile/models/woo_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer_details.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null ? true : false;
  }

  static Future<WooUserModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("login_details") != null
        ? WooUserModel.fromJson(
            jsonDecode(prefs.getString("login_details") ?? ""))
        : WooUserModel();
  }

  static Future<void> setLoginDetails(WooUserModel model) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("login_details", jsonEncode(model.toJson()));
  }

  static Future<void> logout() async {
    await setLoginDetails(WooUserModel());
  }

  static Future<bool> storeShippingAddress(Shipping shipping) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("my_shipping", jsonEncode(shipping.toJson()));
    return true;
  }

  static Future<Shipping> getShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("my_shipping") != null
        ? Shipping.fromJson(jsonDecode(prefs.getString("my_shipping") ?? ""))
        : Shipping();
  }
}
