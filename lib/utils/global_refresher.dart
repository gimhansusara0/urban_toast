import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/services/api_service.dart';

class GlobalRefresher {
  /// Call this from anywhere to refresh all app data
  static Future<void> refreshAll(BuildContext context) async {
    debugPrint("🔄 Starting global data refresh...");
    try {
      ApiService.clearMemoryCache();

      await Future.wait([
        context.read<HomeCategoryProvider>().loadCategories(context),
        context.read<MenuCategoryProvider>().loadCategories(context),
        ApiService.fetchProducts(context),
      ]);

      debugPrint("Global refresh completed");
    } catch (e) {
      debugPrint("Global refresh failed: $e");
    }
  }
}
