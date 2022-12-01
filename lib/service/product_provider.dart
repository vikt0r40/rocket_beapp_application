import 'package:be_app_mobile/service/woocommerce_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { initial, loading, stable }

class ProductProvider with ChangeNotifier {
  WooService _apiService = WooService();
  List<Product> _productList = [];
  SortBy _sortBy = SortBy("modified", "Latest", "asc");

  int pageSize = 20;

  List<Product> get allProducts => _productList;
  double get totalRecords => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.stable;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    resetStreams();
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = WooService();
    _productList = [];
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(
    pageNumber, {
    String? strSearch,
    String? tagName,
    String? categoryId,
    String? sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> itemModel = await _apiService.getProducts(
      strSearch: strSearch,
      tagName: tagName,
      pageNumber: pageNumber,
      pageSize: 20,
      categoryId: categoryId,
      sortBy: _sortBy.value,
      sortOrder: _sortBy.sortOrder,
    );
    if (pageNumber == 1) {
      _productList.clear();
    }
    if (itemModel.isNotEmpty) {
      _productList.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.stable);
    notifyListeners();
  }
}
