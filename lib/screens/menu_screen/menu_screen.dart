import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';
import 'package:urban_toast/screens/menu_screen/components/menu_category_scroller.dart';
import 'package:urban_toast/screens/menu_screen/components/menu_product_scroller.dart';
import 'package:urban_toast/screens/menu_screen/components/products_top_bar.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/screens/menu_screen/components/landscape/landscape_menu_category_scroller.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final catProv = context.read<MenuCategoryProvider>();
      final prodProv = context.read<MenuProductProvider>();
      catProv.loadCategories(context);
      prodProv.loadProducts(context);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _portraitBuilder(context)
            : _landscapeBuilder(context);
      },
    );
  }

  Widget _portraitBuilder(BuildContext context) {
    return SafeArea(
      child: Column(
        children: const [
          ProductsTopBar(),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: MenuCategoryScroller(),
          ),
          Expanded(child: MenuProductScroller())
        ],
      ),
    );
  }

  Widget _landscapeBuilder(BuildContext context) {
    return SafeArea(
      child: Row(
        children: const [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Menu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 50, child: LandscapeMenuCategoryScroller()),
                Expanded(child: MenuProductScroller(crossaxiscount: 4))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
