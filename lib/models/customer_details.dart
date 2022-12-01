class CustomerDetail {
  int id = 0;
  String firstName = "";
  String lastName = "";
  Billing billing = Billing();
  Shipping shipping = Shipping();

  CustomerDetail({this.firstName = "", this.lastName = ""});

  CustomerDetail.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    if (json['first_name'] != null) {
      firstName = json['first_name'];
    }
    if (json['last_name'] != null) {
      lastName = json['last_name'];
    }
    if (json['billing'] != null) {
      billing = Billing.fromJson(json['billing']);
    }
    if (json['shipping'] != null) {
      shipping = Shipping.fromJson(json['billing']);
    }
  }
}

class Billing {
  String firstName = "";
  String lastName = "";
  String company = "";
  String address1 = "";
  String address2 = "";
  String city = "";
  String postcode = "";
  String country = "";
  String state = "";
  String email = "";
  String phone = "";

  Billing(
      {this.firstName = "",
      this.lastName = "",
      this.company = "",
      this.address1 = "",
      this.address2 = "",
      this.city = "",
      this.postcode = "",
      this.country = "",
      this.state = "",
      this.email = "",
      this.phone = ""});

  Billing.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    company = json['company'] ?? "";
    address1 = json['address_1'] ?? "";
    address2 = json['address_2'] ?? "";
    city = json['city'] ?? "";
    postcode = json['postcode'] ?? "";
    country = json['country'] ?? "";
    state = json['state'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['country'] = country;
    data['state'] = state;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Shipping {
  String firstName = "";
  String lastName = "";
  String company = "";
  String address1 = "";
  String address2 = "";
  String city = "";
  String postcode = "";
  String country = "";
  String state = "";

  Shipping({
    this.firstName = "",
    this.lastName = "",
    this.company = "",
    this.address1 = "",
    this.address2 = "",
    this.city = "",
    this.postcode = "",
    this.country = "",
    this.state = "",
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    company = json['company'] ?? "";
    address1 = json['address_1'] ?? "";
    address2 = json['address_2'] ?? "";
    city = json['city'] ?? "";
    postcode = json['postcode'] ?? "";
    country = json['country'] ?? "";
    state = json['state'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['country'] = country;
    data['state'] = state;

    return data;
  }
}
