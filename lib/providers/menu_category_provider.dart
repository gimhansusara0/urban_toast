import 'package:flutter/material.dart';
import 'package:urban_toast/models/category_model.dart';
import 'package:urban_toast/services/api_service.dart';

class MenuCategoryProvider with ChangeNotifier {
  int _selectedCategoryId = 0;
  List<Category> _categories = [Category(id: 0, name: 'All')];
  bool _loading = false;

  int get selectedCategoryId => _selectedCategoryId;
  List<Category> get allCategories => _categories;
  bool get isLoading => _loading;

  void setCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> loadCategories(BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      final fetched = await ApiService.fetchCategories(context);
      _categories = [Category(id: 0, name: 'All'), ...fetched];
    } catch (e) {
      debugPrint(' Error loading categories: $e');
    }

    _loading = false;
    notifyListeners();
  }
}
