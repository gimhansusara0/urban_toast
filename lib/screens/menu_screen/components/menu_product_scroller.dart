import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/data/product_data.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';

class MenuProductScroller extends StatelessWidget {
  final int crossaxiscount;
  const MenuProductScroller({super.key, this.crossaxiscount = 2});

  @override
  Widget build(BuildContext context) {
    final categoryId = context.watch<MenuCategoryProvider>().selectedCategoryId;

    final List<Product> products = categoryId == 0
        ? ProductData.getAllProducts()
        : ProductData.getProductsByCategory(categoryId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossaxiscount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name.length > 13
                                ? '${product.name.substring(0, 13)}...'
                                : product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('\$${product.price.toStringAsFixed(2)}'),
                        ],
                      ),

                      SizedBox(
                        width: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
