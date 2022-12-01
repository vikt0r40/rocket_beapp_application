import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/customer_details.dart';
import 'package:be_app_mobile/models/variable_product.dart';
import 'package:be_app_mobile/models/woo_order.dart';
import 'package:be_app_mobile/models/woo_user_model.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/service/stripe_service.dart';
import 'package:be_app_mobile/service/woocommerce_service.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../helpers/shared_service.dart';
import '../../../../models/product.dart';
import '../form_helper/form_helper.dart';

class VerifyAddress extends StatefulWidget {
  const VerifyAddress({Key? key, this.variableProduct, this.product, required this.appModel}) : super(key: key);
  final VariableProduct? variableProduct;
  final Product? product;
  final BeAppModel appModel;
  @override
  State<VerifyAddress> createState() => _VerifyAddressState();
}

class _VerifyAddressState extends State<VerifyAddress> {
  CustomerDetail model = CustomerDetail();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: mainWidget());
    } else {
      return mainWidget();
    }
  }

  Widget mainWidget() {
    return Scaffold(
      body: isProcessing
          ? Loading(
              general: widget.appModel.general,
            )
          : Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                _formUI()
              ],
            ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      primary: false,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(10),
                        elevation: 0,
                        color: Colors.black87,
                        highlightElevation: 0,
                        minWidth: double.minPositive,
                        height: double.minPositive,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    mainLocalization.localization.wooShippingAddress,
                    style: getFontStyle(22, Colors.black, FontWeight.bold, widget.appModel.general),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.textInput(context, model.shipping.firstName, (value) {
                      model.shipping.firstName = value;
                    }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooFirstName),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FormHelper.textInput(context, model.shipping.lastName, (value) {
                        model.shipping.lastName = value;
                      }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooLastName),
                    ),
                  )
                ],
              ),
              FormHelper.textInput(context, model.shipping.address1, (value) {
                model.shipping.address1 = value;
              }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooAddressName),
              FormHelper.textInput(context, model.shipping.address2, (value) {
                model.shipping.address2 = value;
              }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooPhone),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.textInput(context, model.shipping.country, (value) {
                      model.shipping.country = value;
                    }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooCountry),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FormHelper.textInput(context, model.shipping.state, (value) {
                        model.shipping.state = value;
                      }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooState),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: FormHelper.textInput(context, model.shipping.city, (value) {
                      model.shipping.city = value;
                    }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooCity),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FormHelper.textInput(context, model.shipping.postcode, (value) {
                        model.shipping.postcode = value;
                      }, onValidate: (value) {}, icon: null, hintText: mainLocalization.localization.wooPostCode),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: showPayOnDelivery(),
                child: Center(
                  child: FormHelper.saveButton(mainLocalization.localization.wooPayDelivery, context, () {
                    payOnDelivery();
                  }, fullWidth: true, textColor: "", color: ''),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  payOnDelivery() {
    processOrderInWooCommerce(true);
  }

  payWithStripe() async {
    String productPrice = widget.product?.loadPrice() ?? "";
    double price = double.parse(productPrice);
    double totalPrice = price * 100;

    var paymentIntent = await StripeService.createPaymentIntent(totalPrice.round().toString(), storeCurrency);

    // 3. display the payment sheet.
    try {
      processOrderInWooCommerce(false);
    } catch (e) {
      //error with paying witg stripe
    }
  }

  bool showPayWithStripe() {
    if (widget.appModel.wooConfig?.enableStripe ?? false) {
      return true;
    } else {
      return false;
    }
  }

  bool showPayOnDelivery() {
    if (widget.appModel.wooConfig?.enablePayOnDelivery ?? false) {
      return true;
    } else {
      return false;
    }
  }

  void processOrderInWooCommerce(bool payOnDelivery) async {
    setState(() {
      isProcessing = true;
    });
    WooUserModel userModel = await SharedService.loginDetails();

    WooOrder order = WooOrder();
    order.customerId = userModel.data.id;
    order.setPaid = !payOnDelivery;
    order.shipping = model.shipping;
    if (payOnDelivery) {
      order.paymentMethodTitle = "Pay on delivery";
      order.paymentMethod = "pay_on_delivery";
      order.transactionId = "pay_on_delivery";
    } else {
      order.paymentMethodTitle = "Stripe";
      order.paymentMethod = "stripe";
      order.transactionId = "paid_with_stripe";
    }
    order.currency = storeCurrency;
    LineItems item = LineItems();
    item.productId = widget.product?.id ?? 0;
    if (widget.product?.variableProduct != null) {
      item.variationId = widget.product?.variableProduct.id ?? 0;
    }
    order.orderTotal = widget.product?.loadPrice() ?? "0";
    item.productName = widget.product?.name ?? "";
    item.quantity = 1;
    item.totalAmount = double.parse(widget.product?.loadPrice() ?? "0");
    order.lineItems = [item];
    bool success = await WooService().createOrder(order);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop(false);
    }
  }

  bool showOrText() {
    if (widget.appModel.wooConfig?.enablePayOnDelivery == false || widget.appModel.wooConfig?.enableStripe == false) {
      return false;
    } else {
      return true;
    }
  }
}
