import 'package:flutter/material.dart';
import 'package:urban_toast/screens/menu_screen/components/menu_category_scroller.dart';
import 'package:urban_toast/screens/menu_screen/components/products_top_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

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
  
  return SizedBox(
    width: double.infinity,
    height: MediaQuery.of(context).size.height,
    child: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductsTopBar(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: MenuCategoryScroller(),
            )
          ],
      
        ),
      ),
    ),
  );
}

Widget _landscapeBuilder(BuildContext context) {
  return Center(
  );
}