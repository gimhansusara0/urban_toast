import 'package:flutter/material.dart';
import 'package:urban_toast/screens/product_detail_screen/components/product_img.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProductImage(),
              )
            ],
          ),
        ),
      ),
    );
  }
}