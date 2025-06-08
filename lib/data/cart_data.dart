import 'package:urban_toast/models/product_model.dart';
import 'package:urban_toast/data/product_data.dart'; // or wherever your ProductData is

class CartData {
  static final List<Product> cartItems = [
    ProductData.products[5],
    ProductData.products[3], 
    ProductData.products[6], 
    ProductData.products[2], 
    ProductData.products[1], 
  ];
}
