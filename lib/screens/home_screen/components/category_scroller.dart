import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';

class CategoryScroller extends StatefulWidget {
  const CategoryScroller({super.key});

  @override
  State<CategoryScroller> createState() => _CategoryScrollerState();
}

class _CategoryScrollerState extends State<CategoryScroller> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HomeCategoryProvider>().loadCategories(context);
      });
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<HomeCategoryProvider>();

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
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final category = categories[index];
                final isSelected =
                    category.id == categoryProvider.selectedCategoryId;

                return GestureDetector(
                  onTap: () =>
                      categoryProvider.setCategory(category.id),
                  child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(15, 2, 15, 2),
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400),
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
