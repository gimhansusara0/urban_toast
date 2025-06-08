import 'package:flutter/material.dart';
import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/screens/product_detail_screen/components/landscape/product_content_landscape.dart';
import 'package:urban_toast/screens/product_detail_screen/components/landscape/product_img_landscape.dart';
import 'package:urban_toast/screens/product_detail_screen/components/product_content.dart';
import 'package:urban_toast/screens/product_detail_screen/components/product_img.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
      return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _portraitBuilder(context, product);
        } else {
          return _landscapeBuilder(context, product);
        }
      },
    );
  }
}

Widget _portraitBuilder(BuildContext context, Product product) {
  return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProductImage(product: product),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ProductContent(product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _landscapeBuilder(BuildContext context, Product product) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5, 
            height: MediaQuery.of(context).size.height * 0.8, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProductImageLandscape(product: product, height: 0.8,),
              ],
            ),
          ),
          
            SingleChildScrollView(
              child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4, 
              height: MediaQuery.of(context).size.height * 0.8, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProductContentLandscape(product: product),
                ],
              ),
                        ),
            ),

        ],
      ),
    ),
  );
}





















//     return Scaffold(
//       body: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: ProductImage(product: product),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: ProductContent(product: product),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
