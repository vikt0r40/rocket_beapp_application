import 'package:be_app_mobile/models/variable_product.dart';

class Product {
  int id = 0;
  String type = "";
  String name = "";
  String description = "";
  String shortDescription = "";
  String sku = "";
  String price = "";
  String regularPrice = "";
  String salePrice = "";
  String stockStatus = "";
  String permalink = "";
  bool onSale = false;
  List<Images> images = <Images>[];
  List<Categories> categories = <Categories>[];
  List<Attributes> attributes = <Attributes>[];
  List<int> relatedIds = <int>[];
  VariableProduct variableProduct = VariableProduct();

  Product();

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    shortDescription = json['short_description'] ?? "";
    sku = json['sku'] ?? "";
    price = json['price'] ?? "";
    permalink = json['permalink'];
    regularPrice = json['regular_price'] ?? "";
    salePrice = json['sale_price'] ?? "";
    stockStatus = json['stock_status'] ?? "";
    onSale = json['on_sale'] ?? "";
    if (json['cross_sell_ids'] != null) {
      relatedIds = json['cross_sell_ids'].cast<int>();
    } else {
      relatedIds = [];
    }
    type = json['type'] ?? "";
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(Categories.fromJson(v));
      });
    }

    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }

    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json["attributes"].forEach((v) {
        attributes.add(Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['short_description'] = shortDescription;
    data['sku'] = sku;
    data['price'] = price;

    data['permalink'] = permalink;

    data['regular_price'] = regularPrice;

    data['sale_price'] = salePrice;

    data['stock_status'] = stockStatus;

    data['on_sale'] = onSale;

    data['cross_sell_ids'] = relatedIds;

    data['type'] = type;

    data["categories"] = categories.map((v) => v.toJson()).toList();

    data["images"] = images.map((v) => v.toJson()).toList();

    data["attributes"] = attributes.map((v) => v.toJson()).toList();

    return data;
  }

  String loadPrice() {
    if (price.isEmpty) {
      price = "0.0";
    }
    if (type == "variable") {
      return price;
    } else {
      return salePrice == ""
          ? regularPrice == ""
              ? "0.00"
              : regularPrice
          : salePrice;
    }
  }

  calculateDiscount() {
    double disPercent = 0;
    if (regularPrice != "") {
      double regularPrice = double.parse(this.regularPrice);
      double salePrice = this.salePrice != "" ? double.parse(this.salePrice) : regularPrice;
      double discount = regularPrice - salePrice;
      disPercent = (discount / regularPrice) * 100;
    }
    return disPercent.round();
  }

  shouldOnSaleBeVisisble() {
    if (type == "variable") {
      if (onSale == true) {
        return true;
      }
      return false;
    } else {
      if (calculateDiscount() > 0) {
        return true;
      }
      return false;
    }
  }

  isVariable() {
    if (type == "variable") {
      return true;
    }
    return false;
  }
}

class Categories {
  int id = 0;
  String name = "";

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Images {
  String src = "";

  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['src'] = src;

    return data;
  }
}

class Attributes {
  int id = 0;
  String name = "";
  List<dynamic> options = [];
  String option = "";

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    option = json['option'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['option'] = option;

    return data;
  }
}
