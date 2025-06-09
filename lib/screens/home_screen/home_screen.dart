import 'package:flutter/material.dart';
import 'package:urban_toast/screens/home_screen/components/category_scroller.dart';
import 'package:urban_toast/screens/home_screen/components/product_scroller.dart';
import 'package:urban_toast/screens/home_screen/components/promo_card.dart';
import 'package:urban_toast/screens/home_screen/components/search_bar.dart';
import 'package:urban_toast/screens/home_screen/components/top_ribbon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    child: SingleChildScrollView(
      child: Column(
        children: [
          TopRibbon(),
          Search_Bar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: PromoCard(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: CategoryScroller(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: ProductScroller(),
          ),
        ],
      ),
    ),
  );
}

Widget _landscapeBuilder(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopRibbon(),
                
                PromoCard(height_val: 180, alignment: Alignment.topCenter,),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: CategoryScroller()),
                ProductScroller()
            ],),
          ),
        ],
      ),
    ),
  );
}
