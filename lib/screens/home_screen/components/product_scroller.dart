import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/data/product_data.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/providers/home_category_provider.dart';
import 'package:urban_toast/screens/product_detail_screen/product_detail.dart';

class ProductScroller extends StatelessWidget {
  const ProductScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryId = context.watch<HomeCategoryProvider>().selectedCategoryId;

    final List<Product> products = categoryId == 0
        ? ProductData.getAllProducts()
        : ProductData.getProductsByCategory(categoryId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (_, index) {
  final product = products[index];
  return GestureDetector(
    onTap: () {
      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => ProductDetail(product: product,),
                          transitionsBuilder: (_, animation, __, child) {
                            final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                            final slide = Tween(begin: Offset(0, 1), end: Offset.zero).animate(curved);
                           final fade = Tween(begin: 0.0, end: 1.0).animate(curved);
                            return SlideTransition(
                              position: slide,
                              child: FadeTransition(opacity: fade, child: child),
                            );
                          },
                        ),
                        (route) => false,
                      );
    },
    child: Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 140,
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
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('\$${product.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    ),
  );
},

        ),
      ),
    );
  }
}
