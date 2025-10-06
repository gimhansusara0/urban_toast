import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';

class MenuCategoryScroller extends StatefulWidget {
  const MenuCategoryScroller({super.key});

  @override
  State<MenuCategoryScroller> createState() => _MenuCategoryScrollerState();
}

class _MenuCategoryScrollerState extends State<MenuCategoryScroller> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      context.read<MenuCategoryProvider>().loadCategories(context);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<MenuCategoryProvider>();

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
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
                  onTap: () => categoryProvider.setCategory(category.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
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
                          color: isSelected ? Colors.white : Colors.black87,
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
