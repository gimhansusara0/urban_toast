import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';

class ProductContent extends StatefulWidget {
  final Product product;
  const ProductContent({super.key, required this.product});

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  String selectedSize = 'S';
  final sizes = ['S', 'M', 'L'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text('Description', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
              const Text(
                'Dark, rich espresso lies in wait under a smoothed and stretched layer of thick milk foam.',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Size', style: TextStyle(fontSize: 15)),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: sizes.map((size) {
                  final isSelected = size == selectedSize;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedSize = size),
                      child: Container(
                        width: 80,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.transparent
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(color: Color(0xFFD48B5C), width: 2)
                              : null,
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            color: isSelected
                                ? Color(0xFFD48B5C)
                                : Theme.of(context).brightness ==
                                      Brightness.light
                                ? Theme.of(context).primaryColorDark
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Price'), SizedBox(height: 5), Text('Rs.3.40')],
              ),

              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Order Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
