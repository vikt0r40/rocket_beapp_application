import 'customer_details.dart';

class WooOrder {
  int customerId = 0;
  String paymentMethod = "";
  String paymentMethodTitle = "";
  bool setPaid = false;
  String transactionId = "";
  List<LineItems> lineItems = [];
  int orderId = 0;
  String orderNumber = "";
  String status = "";
  DateTime orderDate = DateTime.now();
  Shipping shipping = Shipping();
  String orderTotal = "";
  String currency = "";
  String shippingTotal = "";
  double itemTotalAmount = 0;

  WooOrder();

  WooOrder.fromJson(Map<String, dynamic> json) {
    customerId = json["customer_id"] ?? 0;
    orderId = json['id'] ?? "";
    status = json['status'] ?? "";
    orderNumber = json['order_key'] ?? "";
    if (json['date_created'] != null) {
      orderDate = DateTime.parse(json['date_created']);
    }
    orderTotal = json['total'] ?? 0;
    paymentMethodTitle = json['payment_method_title'] ?? "";
    currency = json['currency'] ?? "";
    if (json['shipping'] != null) {
      shipping = Shipping.fromJson(json['shipping']);
    }
    shippingTotal = json['shipping_total'] ?? 0;
    if (json['line_items'] != null) {
      lineItems = [];
      json['line_items'].forEach((v) {
        lineItems.add(LineItems.fromJson(v));
      });

      itemTotalAmount =
          lineItems.map<double>((m) => m.totalAmount).reduce((a, b) => a + b);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["customer_id"] = customerId;
    data["payment_method"] = paymentMethod;
    data["payment_method_title"] = paymentMethodTitle;
    data["set_paid"] = setPaid;
    data["transaction_id"] = transactionId;
    data["shipping"] = shipping;
    data["line_items"] = lineItems.map((v) => v.toJson()).toList();
    return data;
  }
}

class LineItems {
  int productId = 0;
  int quantity = 1;
  int variationId = 1;
  String productName = "";
  double totalAmount = 0;

  LineItems();

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] ?? 0;
    productName = json['name'] ?? "";
    variationId = json['variation_id'] ?? 0;
    quantity = json['quantity'] ?? 0;
    if (json['total'] != null) {
      totalAmount = double.parse(json['total']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_id"] = productId;
    data["quantity"] = quantity;
    if (variationId > 0) {
      data["variation_id"] = variationId;
    }
    return data;
  }
}
