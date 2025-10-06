import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientService {
  static const String jsonUrl = "https://github.com/gimhansusara0/Urban-Toast-Ingredients-Data/blob/main/ingredients_data.json";

  static Future<List<String>?> fetchIngredientsForProduct(int productId) async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey(productId.toString())) {
          return List<String>.from(data[productId.toString()]);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
