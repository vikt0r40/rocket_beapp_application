import 'dart:convert';

import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String apiBaseURL = 'https://api.stripe.com/v1';
  static String paymentApiURL = '$apiBaseURL/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer $stripeSecret',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  StripeService();

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<dynamic, dynamic> body = {
        'amount': amount, //multiply by 100
        'currency': currency.toLowerCase(),
        'payment_method_types[]': 'card'
      };
      var response = await http.post(Uri.parse(paymentApiURL),
          body: body, headers: headers);
      return jsonDecode(response.body);
    } on PlatformException catch (err) {
      return getPlatformExceptionErrorResult(err);
    } catch (err) {
      return {};
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction candelled';
    }

    return {"error": message};
  }
}
