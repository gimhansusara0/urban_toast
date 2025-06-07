import 'package:flutter/material.dart';
import 'package:urban_toast/models/category_model.dart';
import 'package:urban_toast/data/category_data.dart';

class HomeCategoryProvider with ChangeNotifier {
  int _selectedCategoryId = categories.first.id;

  int get selectedCategoryId => _selectedCategoryId;

  void setCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  List<Category> get allCategories => categories;
}
