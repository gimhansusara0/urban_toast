import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';
import 'package:urban_toast/screens/menu_screen/components/menu_category_scroller.dart';
import 'package:urban_toast/screens/menu_screen/components/menu_product_scroller.dart';
import 'package:urban_toast/screens/menu_screen/components/products_top_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<MenuCategoryProvider>();
    final prodProv = context.watch<MenuProductProvider>();

    if (!catProv.isInitialized) catProv.loadCategories(context);
    if (!prodProv.isInitialized) prodProv.loadProducts(context);

    return SafeArea(
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Collapsible part TopBar and Carousel
          SliverToBoxAdapter(
            child: const ProductsTopBar(),
          ),

          // Sticky category scroller
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const MenuCategoryScroller(),
              ),
            ),
          ),
        ],
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: MenuProductScroller(),
        ),
      ),
    );
  }
}

// Custom delegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 100; // increased from 70
  @override
  double get maxExtent => 100;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
}
