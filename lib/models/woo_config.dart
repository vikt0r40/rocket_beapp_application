class WooConfig {
  String website = "";
  String wooKey = "";
  String wooSecret = "";
  String stripeSecretKey = "";
  String stripePublishableKey = "";
  String stripeShopName = "";
  String stripeCountryCode = "";
  bool enableWooAuthorization = false;
  bool enablePayments = false;
  bool enableStripe = false;
  bool enablePayOnDelivery = false;

  WooConfig();

  WooConfig.fromJson(Map<dynamic, dynamic> json) {
    website = json["website"] ?? "";
    wooKey = json["wooKey"] ?? "";
    wooSecret = json["wooSecret"] ?? "";
    stripePublishableKey = json['stripePublishableKey'] ?? "";
    stripeShopName = json['stripeShopName'] ?? "";
    stripeCountryCode = json['stripeCountryCode'] ?? "";
    stripeSecretKey = json["stripeSecretKey"] ?? "";
    enableWooAuthorization = json["enableWooAuthorization"] ?? false;
    enablePayments = json["enablePayments"] ?? false;
    enableStripe = json["enableStripe"] ?? false;
    enablePayOnDelivery = json["enablePayOnDelivery"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["website"] = website;
    data["wooKey"] = wooKey;
    data["wooSecret"] = wooSecret;
    data["stripeSecretKey"] = stripeSecretKey;
    data["enableWooAuthorization"] = enableWooAuthorization;
    data["enablePayments"] = enablePayments;
    data["enableStripe"] = enableStripe;
    data["enablePayOnDelivery"] = enablePayOnDelivery;
    data["stripePublishableKey"] = stripePublishableKey;
    data["stripeShopName"] = stripeShopName;
    data["stripeCountryCode"] = stripeCountryCode;
    return data;
  }

  String getWebsiteUrl() {
    if (website.endsWith("/")) {
      return website;
    } else {
      return website + "/";
    }
  }
}
