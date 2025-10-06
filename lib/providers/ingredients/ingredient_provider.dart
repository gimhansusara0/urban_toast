import 'package:flutter/material.dart';
import 'package:urban_toast/services/ingredient_services.dart';

class IngredientProvider extends ChangeNotifier {
  bool isLoading = false;
  List<String> ingredients = [];

  Future<void> loadIngredients(int productId) async {
    isLoading = true;
    ingredients = [];
    notifyListeners();

    final data = await IngredientService.fetchIngredientsForProduct(productId);

    ingredients = data;
    isLoading = false;
    notifyListeners();
  }

  void clear() {
    ingredients = [];
    isLoading = false;
    notifyListeners();
  }
}
