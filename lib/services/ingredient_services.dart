import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientService {
  static const String jsonUrl =
      "https://raw.githubusercontent.com/gimhansusara0/Urban-Toast-Ingredients-Data/main/ingredients_data.json";

  static Map<String, dynamic>? _cache;

  static Future<List<String>> fetchIngredientsForProduct(int productId) async {
    try {
      // Use cached data if available
      if (_cache == null) {
        final response = await http.get(Uri.parse(jsonUrl));
        if (response.statusCode == 200) {
          _cache = jsonDecode(response.body);
        } else {
          throw Exception("Failed to load ingredient JSON");
        }
      }

      final data = _cache?[productId.toString()];
      if (data is List) {
        return List<String>.from(data);
      }
      return [];
    } catch (e) {
      print("⚠️ IngredientService error: $e");
      return [];
    }
  }
}
