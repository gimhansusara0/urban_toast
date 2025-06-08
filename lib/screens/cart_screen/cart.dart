import 'package:flutter/material.dart';
import 'package:urban_toast/data/cart_data.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/screens/cart_screen/components/build_cart_item.dart';
import 'package:urban_toast/screens/cart_screen/components/build_summary.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _portraitBuilder(context);
        } else {
          return _landscapeBuilder(context);
        }
      },
    );
  }
}

Widget _portraitBuilder(BuildContext context) {
  final List<Product> cartItems = CartData.cartItems;
  double total = cartItems.fold(0, (sum, item) => sum + item.price);

  return SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Your Cart',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return CartItem(item: item);
            },
          ),
        ),
        BuildSummary(total: total)
      ],
    ),
  );
}

Widget _landscapeBuilder(BuildContext context) {
  final List<Product> cartItems = CartData.cartItems;
  double total = cartItems.fold(0, (sum, item) => sum + item.price);

  return Row(
    children: [
      Expanded(
        flex: 3,
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return CartItem(item: item);
          },
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Text('Your Cart', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
            ),
            BuildSummary(total: total),
          ],
        ),
      ),
    ],
  );
}

