import 'package:flutter/material.dart';
import 'package:urban_toast/models/category_model.dart';
import 'package:urban_toast/services/api_service.dart';

class MenuCategoryProvider with ChangeNotifier {
  bool isLoading = false;
  int selectedCategoryId = 0;
  List<Category> allCategories = [];

  Future<void> loadCategories(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      allCategories = await ApiService.fetchCategories(context);
    } catch (e) {
      debugPrint("Error loading categories: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(int id) {
    if (selectedCategoryId == id) return;
    selectedCategoryId = id;
    notifyListeners();
  }
}
