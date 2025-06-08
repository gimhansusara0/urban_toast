import 'package:urban_toast/models/product_model.dart';

class ProductData {
  static final List<Product> products = [
    Product(
      id: 1,
      name: 'Espresso',
      price: 2.99,
      image: 'https://www.sharmispassions.com/wp-content/uploads/2012/07/espresso-coffee-recipe04-500x500.jpg',
      categoryId: 1,
    ),
    Product(
      id: 2,
      name: 'Iced Latte',
      price: 3.99,
      image: 'https://www.forkinthekitchen.com/wp-content/uploads/2022/08/220629.iced_.latte_.vanilla-9009-500x500.jpg',
      categoryId: 2,
    ),
  ];

  static List<Product> getAllProducts() => products;

  static List<Product> getProductsByCategory(int categoryId) {
    return products.where((p) => p.categoryId == categoryId).toList();
  }
}
