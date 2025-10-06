import 'package:flutter/material.dart';
import 'package:urban_toast/models/category_model.dart';
import 'package:urban_toast/services/api_service.dart';

class MenuCategoryProvider with ChangeNotifier {
  int _selectedCategoryId = 0;
  List<Category> _categories = [Category(id: 0, name: 'All')];
  bool _loading = false;
  bool _initialized = false; // prevents multiple fetches

  int get selectedCategoryId => _selectedCategoryId;
  List<Category> get allCategories => _categories;
  bool get isLoading => _loading;
  bool get isInitialized => _initialized;

  void setCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> loadCategories(BuildContext context) async {
    if (_initialized) return; // Only load once

    _loading = true;
    notifyListeners();

    try {
      final fetched = await ApiService.fetchCategories(context);
      _categories = [Category(id: 0, name: 'All'), ...fetched];
      _initialized = true;
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
