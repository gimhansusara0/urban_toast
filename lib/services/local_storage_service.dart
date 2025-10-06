import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/category_model.dart';
import 'dart:convert';

class LocalStorageService {
  static Future<String> _getPath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$fileName.json';
  }

  // Download and cache image
  static Future<String> _cacheImage(String imageUrl) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = Uri.parse(imageUrl).pathSegments.last;
      final filePath = '${dir.path}/images/$fileName';
      final file = File(filePath);

      // Create dir if not exists
      await Directory('${dir.path}/images').create(recursive: true);

      if (!await file.exists()) {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        }
      }

      return file.path;
    } catch (e) {
      return imageUrl; // fallback to URL if anything fails
    }
  }

  // Save products and cache images
  static Future<void> saveProducts(List<Product> products) async {
    final path = await _getPath('products');

    // Cache all images before saving
    final updatedProducts = await Future.wait(products.map((p) async {
      final localPath = await _cacheImage(p.image);
      return {
        'id': p.id,
        'name': p.name,
        'price': p.price,
        'image': localPath,
        'category_id': p.categoryId,
        'description': p.description,
        'rating': p.rating,
      };
    }));

    final file = File(path);
    await file.writeAsString(jsonEncode(updatedProducts));
  }

  static Future<List<Product>?> loadProducts() async {
    final path = await _getPath('products');
    final file = File(path);
    if (!await file.exists()) return null;

    final data = jsonDecode(await file.readAsString()) as List;
    return data.map((x) => Product(
      id: x['id'],
      name: x['name'],
      price: (x['price'] as num).toDouble(),
      image: x['image'],
      categoryId: x['category_id'],
      description: x['description'] ?? '',
      rating: (x['rating'] ?? 0).toDouble(),
    )).toList();
  }

  static Future<void> saveCategories(List<Category> categories) async {
    final path = await _getPath('categories');
    final file = File(path);
    await file.writeAsString(jsonEncode(categories.map((c) => {
      'id': c.id,
      'name': c.name,
    }).toList()));
  }

  static Future<List<Category>?> loadCategories() async {
    final path = await _getPath('categories');
    final file = File(path);
    if (!await file.exists()) return null;

    final data = jsonDecode(await file.readAsString()) as List;
    return data.map((x) => Category(id: x['id'], name: x['name'])).toList();
  }
}
