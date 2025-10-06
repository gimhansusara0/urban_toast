import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/services/api_service.dart';

class MenuProductProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isInitialized = false; // prevents multiple fetches
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;

  Future<void> loadProducts(BuildContext context, {int? categoryId}) async {
    if (_isInitialized) return; // Only load once

    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await ApiService.fetchProducts(context);
      _filterProducts(categoryId ?? 0);
      _isInitialized = true;
    } catch (e) {
      debugPrint("Error loading products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(int categoryId) {
    _filterProducts(categoryId);
    notifyListeners();
  }

  void _filterProducts(int categoryId) {
    if (categoryId == 0) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts =
          _allProducts.where((p) => p.categoryId == categoryId).toList();
    }
  }
}
