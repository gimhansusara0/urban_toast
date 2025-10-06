import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';

class ProductContent extends StatelessWidget {
  final Product product;
  const ProductContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final sizes = ['S', 'M', 'L'];
    String selectedSize = 'S';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(fontSize: 15)),
        const SizedBox(height: 10),
        Text(product.description, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        const Text('Size', style: TextStyle(fontSize: 15)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: sizes.map((size) {
            bool isSelected = size == selectedSize;
            return Container(
              width: 80,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.transparent
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: isSelected
                    ? Border.all(color: const Color(0xFFD48B5C), width: 2)
                    : null,
              ),
              child: Text(
                size,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFD48B5C)
                      : Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColorDark
                          : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Price'),
                const SizedBox(height: 5),
                Text('\$${product.price.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Order Now'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
