import 'package:be_app_mobile/models/product.dart';

class VariableProduct {
  int id = 0;
  String sku = "";
  String price = "";
  String regularPrice = "";
  String salePrice = "";
  List<Attributes> attributes = <Attributes>[];

  VariableProduct();

  VariableProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];

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
    data['sku'] = sku;
    data['price'] = price;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['attributes'] = attributes.map((v) => v.toJson()).toList();
    return data;
  }
}
