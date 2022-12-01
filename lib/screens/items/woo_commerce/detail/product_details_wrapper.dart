import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/detail/product_details.dart';
import 'package:be_app_mobile/service/woocommerce_service.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../models/variable_product.dart';
import '../woo_globals.dart';

class ProductDetailsWrapper extends StatefulWidget {
  const ProductDetailsWrapper({Key? key, required this.product, required this.appModel}) : super(key: key);
  final Product product;
  final BeAppModel appModel;
  @override
  State<ProductDetailsWrapper> createState() => _ProductDetailsWrapperState();
}

class _ProductDetailsWrapperState extends State<ProductDetailsWrapper> {
  WooService apiService = WooService();
  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: mainWidget());
    } else {
      return mainWidget();
    }
  }

  Widget mainWidget() {
    return widget.product.type == "variable"
        ? _variableProductsLists()
        : ProductDetailsWidget(
            data: widget.product,
            appModel: widget.appModel,
          );
  }

  Widget _variableProductsLists() {
    return FutureBuilder(
      future: apiService.getVariableProducts(widget.product.id),
      builder: (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailsWidget(
            data: widget.product,
            variableProducts: model.data,
            appModel: widget.appModel,
          );
        }

        return Center(
          child: Loading(
            general: widget.appModel.general,
          ),
        );
      },
    );
  }
}
