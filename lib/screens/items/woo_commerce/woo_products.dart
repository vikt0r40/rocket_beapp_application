import 'dart:async';

import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/product.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/be_product.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/service/woocommerce_service.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/product_provider.dart';

class WooProductsScreen extends StatefulWidget {
  const WooProductsScreen({Key? key, required this.model, required this.onProductBack, required this.categoryID, required this.tagID})
      : super(key: key);
  final BeAppModel model;
  final String tagID;
  final String categoryID;
  final Function onProductBack;

  @override
  _WooProductsScreenState createState() => _WooProductsScreenState();
}

class _WooProductsScreenState extends State<WooProductsScreen> {
  WooService woo = WooService();

  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final _searchQuery = TextEditingController();
  Timer? _debounce;
  String currentTagID = "";
  String currentCategoryID = "";

  // final _sortByOptions = [
  //   SortBy("price", "Price High", "asc"),
  //   SortBy("price", "Price Low", "desc"),
  // ];

  @override
  void initState() {
    // TODO: implement setState
    currentTagID = widget.categoryID;
    currentCategoryID = widget.tagID;
    var productList = Provider.of<ProductProvider>(context, listen: false);

    productList.resetStreams();

    productList.fetchProducts(_page, categoryId: widget.categoryID, tagName: widget.tagID);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.loading);
        productList.fetchProducts(++_page, categoryId: widget.categoryID, tagName: widget.tagID);
      }
    });

    _onSearchChange() {
      var productList = Provider.of<ProductProvider>(context, listen: false);
      if (_debounce != null) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 2000), () {
        productList.resetStreams();
        productList.setLoadingState(LoadMoreStatus.initial);
        productList.fetchProducts(_page, categoryId: widget.categoryID, tagName: widget.tagID);
      });
    }

    _searchQuery.addListener(_onSearchChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadProduct();
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: _productsList());
    } else {
      return _productsList();
    }
  }

  Widget _productsList() {
    return Consumer<ProductProvider>(builder: (context, productModel, child) {
      if (productModel.allProducts.isNotEmpty && productModel.getLoadMoreStatus() != LoadMoreStatus.initial) {
        return _buildList(productModel.allProducts, productModel.getLoadMoreStatus() == LoadMoreStatus.loading);
      }

      return Center(
        child: Loading(
          general: widget.model.general,
        ),
      );
    });
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    var crossAxisSpacing = 8;
    var screenWidth = MediaQuery.of(context).size.width;
    int numberOfItems = 2;
    if (getDeviceType() == "tablet") {
      numberOfItems = 4;
    }
    var crossAxisCount = numberOfItems;
    var width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) / crossAxisCount;
    var cellHeight = 300;
    var aspectRatio = width / cellHeight;

    return Column(
      children: [
        //_productFilters(),
        Flexible(
            child: GridView.count(
          shrinkWrap: true,
          controller: _scrollController,
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: items.map((Product item) {
            return BeProduct(
              product: item,
              appModel: widget.model,
              onProductBack: widget.onProductBack,
            ); //21:49
          }).toList(),
        )),
        Visibility(
          visible: isLoadMore,
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 35.0,
            width: 35.0,
            child: const CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  void loadProduct() {
    if (widget.categoryID != currentCategoryID || widget.tagID != currentTagID) {
      Future.delayed(const Duration(milliseconds: 500), () {
        var productList = Provider.of<ProductProvider>(context, listen: false);
        productList.setLoadingState(LoadMoreStatus.initial);
        productList.fetchProducts(_page, categoryId: widget.categoryID, tagName: widget.tagID);

        currentTagID = widget.categoryID;
        currentCategoryID = widget.tagID;
      });
    }
  }
}
