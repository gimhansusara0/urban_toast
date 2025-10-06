import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';
import 'package:urban_toast/screens/product_detail_screen/product_detail.dart';

class MenuProductScroller extends StatelessWidget {
  final int crossaxiscount;
  const MenuProductScroller({super.key, this.crossaxiscount = 2});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<MenuProductProvider>();

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final products = productProvider.filteredProducts;
    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

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
          return _ProductCard(product: product);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetail(product: product),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  Flexible(
                    child: Column(
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
                  ),
                  SizedBox(
                    width: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Center(child: Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
