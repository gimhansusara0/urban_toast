import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';

class CategoryScroller extends StatelessWidget {
  const CategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<HomeCategoryProvider>(context);
    final categories = categoryProvider.allCategories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Text('Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),),
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
                final isSelected = category.id == categoryProvider.selectedCategoryId;
          
                return GestureDetector(
                  onTap: () => categoryProvider.setCategory(category.id),
                  child: Container(
                        padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(child: Text(category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w400
                        ),),),
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
