import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';

class CategoryScroller extends StatelessWidget {
  const CategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<HomeCategoryProvider>(context);
    final categories = categoryProvider.allCategories;
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          final isSelected = category.id == categoryProvider.selectedCategoryId;

          return GestureDetector(
            onTap: () => categoryProvider.setCategory(category.id),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown[200] : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text(category.name)),
            ),
          );
        },
      ),
    );

  }
}
