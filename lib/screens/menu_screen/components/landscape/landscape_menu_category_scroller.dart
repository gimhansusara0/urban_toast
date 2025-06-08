import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';

class LandscapeMenuCategoryScroller extends StatelessWidget {
  const LandscapeMenuCategoryScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<MenuCategoryProvider>(context);
    final categories = categoryProvider.allCategories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
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
