import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';

class MenuCategoryScroller extends StatelessWidget {
  const MenuCategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<MenuCategoryProvider>();
    final productProvider = context.read<MenuProductProvider>();

    if (categoryProvider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final categories = categoryProvider.allCategories;
    if (categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('No categories found.')),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final category = categories[index];
                final isSelected =
                    category.id == categoryProvider.selectedCategoryId;

                return GestureDetector(
                  onTap: () {
                    categoryProvider.setCategory(category.id);
                    productProvider.filterByCategory(category.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : (isDark ? Colors.white : Theme.of(context).cardColor),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.4),
                            blurRadius: 6,
                          ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.black : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
