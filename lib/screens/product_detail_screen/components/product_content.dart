import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/models/cart_item.dart';
import 'package:urban_toast/providers/cart/cart_provider.dart';

class ProductContent extends StatefulWidget {
  final Product product;
  const ProductContent({super.key, required this.product});

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  ItemSize selectedSize = ItemSize.s; // default size S

  // dynamically compute price based on size
  double get sizeAdjustedPrice {
    final base = widget.product.price;
    switch (selectedSize) {
      case ItemSize.s:
        return base;
      case ItemSize.m:
        return base + 50;
      case ItemSize.l:
        return base + 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = context.watch<CartProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  Description
        const Text('Description', style: TextStyle(fontSize: 15)),
        const SizedBox(height: 10),
        Text(product.description, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 20),

        // Size selector
        const Text('Size', style: TextStyle(fontSize: 15)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ItemSize.values.map((size) {
            final label = size.label;
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSize = size;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                      : null,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).primaryColorDark
                            : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 25),

        // --- Price + Order button ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Price'),
                const SizedBox(height: 5),
                Text(
                  'Rs. ${sizeAdjustedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final added = cart.addProduct(product, size: selectedSize);
                  if (!added) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item already in cart')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added ${product.name} (${selectedSize.label}) to cart',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Order Now'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
