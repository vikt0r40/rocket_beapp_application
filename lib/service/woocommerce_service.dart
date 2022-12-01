import 'dart:convert';

import 'package:be_app_mobile/models/woo_order.dart';
import 'package:be_app_mobile/models/woo_user.dart';
import 'package:be_app_mobile/models/woo_user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/shared_service.dart';
import '../models/product.dart';
import '../models/variable_product.dart';
import '../screens/items/woo_commerce/woo_globals.dart';

class WooService {
  static String productsURL = "products";
  static String currencyURL = "data/currencies/current";
  static String restApiPath = "wp-json/wc/v3/";
  static String variableProductsURL = "variations";
  static String orderURL = "orders";
  static String shippingURL = "shipping/zones";
  static String customerURL = "customers";

  WooService();

  Future<List<Product>> getProducts({
    int? pageNumber,
    int? pageSize,
    String? strSearch,
    String? tagName,
    String? categoryId,
    List<int>? productIDs,
    String? sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> data = <Product>[];

    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }

      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }

      if (tagName != null) {
        parameter += "&tag=$tagName";
      }

      if (productIDs != null) {
        parameter += "&include=${productIDs.join(",").toString()}";
      }

      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }

      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }

      parameter += "&order=$sortOrder";

      String url = "$website$restApiPath$productsURL?consumer_key=$key&consumer_secret=$secret${parameter.toString()}";

      var response = await Dio().get(url,
          options: Options(headers: {
            "Content-type": "application/json",
          }));

      if (response.statusCode == 200) {
        //data = response.data.map((i) => Product.fromJson(i)).toList();
        for (Map<String, dynamic> pr in response.data) {
          data.add(Product.fromJson(pr));
        }
        data = data.reversed.toList();
        return data;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }

    return data;
  }

  Future<String> getStoreCurrency() async {
    String currency = "USD";
    try {
      String url = "$website$restApiPath$currencyURL?consumer_key=$key&consumer_secret=$secret";
      var response = await Dio().get(url,
          options: Options(headers: {
            "Content-type": "application/x-www-form-urlencoded",
          }));

      if (response.statusCode == 200) {
        currency = response.data["code"];
        return currency;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }

    return currency;
  }

  Future<List<VariableProduct>> getVariableProducts(int productId) async {
    List<VariableProduct> responseModel = [];

    try {
      String url = "$website${restApiPath}products/${productId.toString()}/$variableProductsURL?consumer_key=$key&consumer_secret=$secret";
      var response = await Dio().get(url,
          options: Options(headers: {
            "Content-type": "application/json",
          }));

      if (response.statusCode == 200) {
        responseModel = (response.data as List).map((e) => VariableProduct.fromJson(e)).toList();
        return responseModel;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }

    return responseModel;
  }

  Future<bool> createOrder(WooOrder model) async {
    WooUserModel loginResponseModel = await SharedService.loginDetails();
    bool isLoggedIn = await SharedService.isLoggedIn();

    String token = "";

    model.customerId = loginResponseModel.data.id;
    token = loginResponseModel.data.token;

    if (model.paymentMethod == "cod") {
      model.transactionId = "cod";
    }
    bool isOrderCreated = false;
    String url = "$website$restApiPath$orderURL/?consumer_key=$key&consumer_secret=$secret";

    try {
      if (isLoggedIn) {
        await Dio().post(url,
            data: model.toJson(),
            options: Options(headers: {
              "Authorization": "Basic $token",
              "Content-type": "application/json",
            }));
      } else {
        await Dio().post(url,
            data: model.toJson(),
            options: Options(headers: {
              "Content-type": "application/json",
            }));
      }

      isOrderCreated = true;
      return isOrderCreated;
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return isOrderCreated;
  }

  Future<bool> createCustomer(WooUser model) async {
    var authToken = base64.encode(utf8.encode("$key:$secret"));

    bool ret = false;
    try {
      var response = await Dio().post(website + restApiPath + customerURL,
          data: model.toJson(),
          options: Options(headers: {
            "Authorization": "Basic $authToken",
            "Content-type": "application/json",
          }));

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    return ret;
  }

  Future<WooUserModel> loginCustomer(String username, String password) async {
    WooUserModel model = WooUserModel();
    String url = "${website}wp-json/jwt-auth/v1/token";

    try {
      var response = await Dio().post(url,
          data: {
            "username": username,
            "password": password,
          },
          options: Options(headers: {
            "Content-type": "application/x-www-form-urlencoded",
          }));

      if (response.statusCode == 200) {
        return model = WooUserModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }

    return model;
  }
}
