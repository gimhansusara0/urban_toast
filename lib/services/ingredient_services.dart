import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientService {
  static const String jsonUrl =
      "https://raw.githubusercontent.com/gimhansusara0/Urban-Toast-Ingredients-Data/main/ingredients_data.json";

  static Map<String, dynamic>? _cache;

  static Future<List<String>> fetchIngredientsForProduct(int productId) async {
    try {
      if (_cache == null) {
        final response = await http.get(Uri.parse(jsonUrl));
        if (response.statusCode == 200) {
          _cache = jsonDecode(response.body);
        } else {
          throw Exception("Failed to load ingredient JSON");
        }
      }

      final productData = _cache?[productId.toString()];
      if (productData is Map && productData['ingredients'] is List) {
        return List<String>.from(productData['ingredients']);
      }

      return [];
    } catch (e) {
      print("IngredientService error: $e");
      return [];
    }
  }
}
