class BeAnalytics {
  int visitors = 0;
  int userShares = 0;
  int feedbacks = 0;
  int rates = 0;
  int appleDevices = 0;
  int androidDevices = 0;

  BeAnalytics(
      {this.visitors = 0,
      this.userShares = 0,
      this.feedbacks = 0,
      this.rates = 0,
      this.appleDevices = 0,
      this.androidDevices = 0});

  BeAnalytics.fromJson(Map<dynamic, dynamic> json) {
    visitors = json["visitors"] ?? 0;
    userShares = json["userShares"] ?? 0;
    feedbacks = json["feedbacks"] ?? 0;
    rates = json["rates"] ?? 0;
    appleDevices = json["appleDevices"] ?? 0;
    androidDevices = json["androidDevices"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["visitors"] = visitors;
    data["userShares"] = userShares;
    data["feedbacks"] = feedbacks;
    data["rates"] = rates;
    data["appleDevices"] = appleDevices;
    data["androidDevices"] = androidDevices;
    return data;
  }
}
