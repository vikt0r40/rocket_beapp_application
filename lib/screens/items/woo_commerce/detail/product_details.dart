import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/detail/widget_sizes.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/payment/verify_address.dart';
import 'package:be_app_mobile/widgets/order_success.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../../../../models/product.dart';
import '../../../../models/variable_product.dart';
import '../woo_globals.dart';
import 'expand_text.dart';

class ProductDetailsWidget extends StatefulWidget {
  const ProductDetailsWidget({Key? key, required this.data, this.variableProducts, required this.appModel}) : super(key: key);

  final Product data;
  final BeAppModel appModel;
  final List<VariableProduct>? variableProducts;
  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final CarouselController _controller = CarouselController();
  int quantity = 1;

  VariableProduct selectedProduct = VariableProduct();

  //CartProducts cartProducts = new CartProducts();

  bool isProductInWishlist = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      productImages(widget.data.images, context),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
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
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const FaIcon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Align(
                            alignment: Alignment.topRight,
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
                              onPressed: () {
                                Share.share(widget.data.permalink);
                              },
                              child: const FaIcon(
                                FontAwesomeIcons.shareNodes,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  productContent(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBuyButton()
          ? SafeArea(
              child: Container(
                height: 50,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        proceedToPayment();
                      },
                      color: Colors.black,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        mainLocalization.localization.wooBuyNow,
                        style: getFontStyle(18, Colors.white, FontWeight.normal, widget.appModel.general),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget productContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(widget.data.name,
                    textAlign: TextAlign.start, style: getFontStyle(17, Colors.black, FontWeight.w600, widget.appModel.general)),
              ),
              Visibility(
                visible: true,
                child: Text(NumberFormat.simpleCurrency(name: storeCurrency).format(double.parse(widget.data.loadPrice())),
                    style: getFontStyle(23, Colors.orange[800], FontWeight.normal, widget.appModel.general)),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              Visibility(
                visible: widget.data.attributes.isNotEmpty,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    SizesWidget(
                      sizes: widget.variableProducts ?? [],
                      onSizeSelected: (variableProduct) {
                        setState(() {
                          selectedProduct = variableProduct;
                          widget.data.price = variableProduct.price;
                          widget.data.variableProduct = variableProduct;
                        });
                      },
                      variableProduct: selectedProduct,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpandText(
            labelHeader: mainLocalization.localization.wooProductDetails,
            shortDesc: widget.data.shortDescription,
            desc: widget.data.description,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void proceedToPayment() async {
    bool orderStatus = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyAddress(
                  appModel: widget.appModel,
                  product: widget.data,
                ))) as bool;
    handleOrderSuccess(orderStatus);
  }

  addProductToCart() {}

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      //height: 350,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, value) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: CachedNetworkImage(
                        imageUrl: images[index].src,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                  autoPlay: false, height: MediaQuery.of(context).size.width, enlargeCenterPage: true, viewportFraction: 1, aspectRatio: 1.0),
              carouselController: _controller,
            ),
          ),
          // Positioned(
          //   top: 100,
          //   child: IconButton(
          //     icon: Icon(Icons.arrow_back_ios),
          //     onPressed: () {
          //       _controller.previousPage();
          //     },
          //   ),
          // ),
          // Positioned(
          //   top: 100,
          //   left: MediaQuery.of(context).size.width - 80,
          //   child: IconButton(
          //     icon: Icon(Icons.arrow_forward_ios),
          //     onPressed: () {
          //       _controller.nextPage();
          //     },
          //   ),
          // )
        ],
      ),
    );
  }

  bool showBuyButton() {
    if (widget.appModel.wooConfig?.enablePayments ?? false) {
      return true;
    } else {
      return false;
    }
  }

  void handleOrderSuccess(bool isSuccess) {
    if (isSuccess) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderSuccess(
                    options: widget.appModel.options,
                  )));
    }
  }
}
