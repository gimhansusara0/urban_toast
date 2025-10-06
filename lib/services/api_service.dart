import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/local_storage_service.dart';
import '../utils/network_manager.dart';

class ApiService {
  static const String baseUrl = "http://65.0.197.231/api/v1";

  //  Temporary cache in memeory
  static List<Category>? _cachedCategories;
  static List<Product>? _cachedProducts;

  /// Fetch all categories
  static Future<List<Category>> fetchCategories(BuildContext context) async {
    // memory cache if available
    if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return Future.value(_cachedCategories);
    }

    final isOnline = Provider.of<NetworkManager>(context, listen: false).isOnline;

    if (!isOnline) {
      final cached = await LocalStorageService.loadCategories();
      if (cached != null) {
        _cachedCategories = cached;
        return Future.value(cached);
      }
      throw Exception("No local categories found");
    }

    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded['data'] ?? [];
      final categories = List<Category>.from(
        list.map((x) => Category(id: x['id'], name: x['name'])),
      );

      // Update both memory and disk cache
      _cachedCategories = categories;
      await LocalStorageService.saveCategories(categories);

      return categories;
    } else {
      throw Exception("Failed to load categories");
    }
  }

  /// Fetch all products
  static Future<List<Product>> fetchProducts(BuildContext context) async {
    // Show from in-memory cache if available
    if (_cachedProducts != null && _cachedProducts!.isNotEmpty) {
      return Future.value(_cachedProducts);
    }

    final isOnline = Provider.of<NetworkManager>(context, listen: false).isOnline;

    if (!isOnline) {
      final cached = await LocalStorageService.loadProducts();
      if (cached != null) {
        _cachedProducts = cached;
        return Future.value(cached);
      }
      throw Exception("No local products found");
    }

    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = decoded['data'] ?? [];
      final products = List<Product>.from(list.map((x) => Product(
            id: x['id'],
            name: x['name'],
            price: double.tryParse(x['price'].toString()) ?? 0,
            image: x['image'] ?? '',
            categoryId: x['category_id'],
            description: x['description'] ?? '',
            rating: (x['rating'] ?? 0).toDouble(),
          )));

      // Updates both the memory and disk cache
      _cachedProducts = products;
      await LocalStorageService.saveProducts(products);

      return products;
    } else {
      throw Exception("Failed to load products");
    }
  }

  // Clearing temporary cache on logout or refresh
  static void clearMemoryCache() {
    _cachedProducts = null;
    _cachedCategories = null;
  }
}
