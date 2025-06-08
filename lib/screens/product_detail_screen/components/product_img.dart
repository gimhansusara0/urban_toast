import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:urban_toast/app.dart';
import 'package:urban_toast/models/product_model.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  const ProductImage({super.key, required this.product});

  
  @override
  Widget build(BuildContext context) {
    String product_name = product.name.length > 15 ? product.name.substring(0,15) + '...' : product.name;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: NetworkImage(product.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => MainApp(),
                          transitionsBuilder: (_, animation, __, child) {
                            final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                            final slide = Tween(begin: Offset(1, 0), end: Offset.zero).animate(curved);
                           final fade = Tween(begin: 0.0, end: 1.0).animate(curved);
                            return SlideTransition(
                              position: slide,
                              child: FadeTransition(opacity: fade, child: child),
                            );
                          },
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
                const Icon(Icons.add, color: Colors.white),
              ],
            ),
          ),
          GlassmorphicContainer(
            width: double.infinity,
            height: 100,
            borderRadius: 25,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.light
                  ? [
                      const Color(0xFFFFFFF).withOpacity(0.1),
                      const Color(0xFFFFFFF).withOpacity(0.05),
                    ]
                  : [
                      const Color(0xFF000000).withOpacity(0.1),
                      const Color(0xFF000000).withOpacity(0.05),
                    ],
              stops: [0.1, 1],
            ),
            border: 0,
            blur: 20,
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.light
                  ? [
                      const Color(0xFFFFFFF).withOpacity(0.1),
                      const Color(0xFFFFFFF).withOpacity(0.05),
                    ]
                  : [
                      const Color(0xFF000000).withOpacity(0.1),
                      const Color(0xFF000000).withOpacity(0.05),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product_name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text('Urban Toast', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 28,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.coffee,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 28,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.shopping_bag,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).primaryColorDark,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text('4.6'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
