import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/providers/home_category_provider.dart';
import 'package:urban_toast/screens/product_detail_screen/product_detail.dart';
import 'package:urban_toast/services/api_service.dart';

class ProductScroller extends StatelessWidget {
  const ProductScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryId = context.watch<HomeCategoryProvider>().selectedCategoryId;

    return FutureBuilder<List<Product>>(
      future: ApiService.fetchProducts(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        final products = categoryId == 0
            ? snapshot.data!
            : snapshot.data!.where((p) => p.categoryId == categoryId).toList();

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
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) =>
                            ProductDetail(product: product),
                        transitionsBuilder: (_, animation, __, child) {
                          final curved = CurvedAnimation(
                              parent: animation, curve: Curves.easeInOut);
                          final slide = Tween(
                                  begin: const Offset(0, 1), end: Offset.zero)
                              .animate(curved);
                          final fade =
                              Tween(begin: 0.0, end: 1.0).animate(curved);
                          return SlideTransition(
                            position: slide,
                            child: FadeTransition(
                                opacity: fade, child: child),
                          );
                        },
                      ),
                      (route) => false,
                    );
                  },
                  child: Card(
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.only(right: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      width: 140,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                  imageUrl: product.image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                                )
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
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
      },
    );
  }
}
