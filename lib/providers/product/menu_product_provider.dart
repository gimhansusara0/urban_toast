import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/services/api_service.dart';

class MenuProductProvider with ChangeNotifier {
  bool isLoading = false;
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  Future<void> loadProducts(BuildContext context, {int? categoryId}) async {
    isLoading = true;
    notifyListeners();
    try {
      allProducts = await ApiService.fetchProducts(context);
      _filterProducts(categoryId ?? 0);
    } catch (e) {
      debugPrint("Error loading products: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(int categoryId) {
    _filterProducts(categoryId);
    notifyListeners();
  }

  void _filterProducts(int categoryId) {
    if (categoryId == 0) {
      filteredProducts = List.from(allProducts);
    } else {
      filteredProducts = allProducts.where((p) => p.categoryId == categoryId).toList();
    }
  }
}
