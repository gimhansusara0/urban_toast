import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class LocalStorageService {
  static Future<String> _getPath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName.json';
  }

  static Future<void> saveProducts(List<Product> products) async {
    final filePath = await _getPath('products');
    final file = File(filePath);
    final data = products.map((p) => {
      "id": p.id,
      "name": p.name,
      "price": p.price,
      "image": p.image,
      "category_id": p.categoryId,
      "description": p.description,
      "rating": p.rating
    }).toList();
    await file.writeAsString(jsonEncode(data));
  }

  static Future<void> saveCategories(List<Category> categories) async {
    final filePath = await _getPath('categories');
    final file = File(filePath);
    final data = categories.map((c) => {
      "id": c.id,
      "name": c.name,
    }).toList();
    await file.writeAsString(jsonEncode(data));
  }

  static Future<List<Product>?> loadProducts() async {
    final filePath = await _getPath('products');
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final data = jsonDecode(await file.readAsString()) as List;
    return data.map((x) => Product(
      id: x['id'],
      name: x['name'],
      price: (x['price'] as num).toDouble(),
      image: x['image'],
      categoryId: x['category_id'],
      description: x['description'],
      rating: (x['rating'] ?? 0).toDouble(),
    )).toList();
  }

  static Future<List<Category>?> loadCategories() async {
    final filePath = await _getPath('categories');
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final data = jsonDecode(await file.readAsString()) as List;
    return data.map((x) => Category(
      id: x['id'],
      name: x['name'],
    )).toList();
  }
}
