import 'package:urban_toast/models/product_model.dart';

class ProductData {
  static final List<Product> products = [
   Product(
    id: 1,
    name: 'Latte',
    price: 3.49,
    image: 'https://sweetpotatosoul.com/wp-content/uploads/2024/09/perfect-spiced-sweet-potato-latte-1-500x500.jpg',
    categoryId: 1,
  ),
  Product(
    id: 2,
    name: 'Cappuccino',
    price: 3.29,
    image: 'https://www.pamperedchef.ca/iceberg/com/recipe/2132141-lg.jpg',
    categoryId: 1,
  ),
  Product(
    id: 3,
    name: 'Espresso',
    price: 2.99,
    image: 'https://www.sharmispassions.com/wp-content/uploads/2012/07/espresso-coffee-recipe04-500x500.jpg',
    categoryId: 1,
  ),
  Product(
    id: 4,
    name: 'Iced Coffee',
    price: 3.59,
    image: 'https://www.cookingclassy.com/wp-content/uploads/2022/07/iced-coffee-05-500x500.jpg',
    categoryId: 2,
  ),
  Product(
    id: 5,
    name: 'Cold Brew',
    price: 3.99,
    image: 'https://sundaytable.co/wp-content/uploads/2024/03/grind-size-for-cold-brew-coffee-concentrate-1-500x500.jpg',
    categoryId: 2,
  ),
  Product(
    id: 6,
    name: 'Caramel Frappuccino',
    price: 4.49,
    image: 'https://thebusybaker.ca/wp-content/uploads/2020/05/easy-caramel-frappuccino-fb-ig-5-500x500.jpg',
    categoryId: 3,
  ),
  Product(
    id: 7,
    name: 'Java Chip Frappuccino',
    price: 4.79,
    image: 'https://amagicalmess.com/wp-content/uploads/2020/09/java-chip-frappuccino-2-500x500.jpg',
    categoryId: 3,
  ),
  Product(
    id: 8,
    name: 'Chai Tea Latte',
    price: 3.99,
    image: 'https://liliebakery.fr/wp-content/uploads/2022/10/Chai-latte-recette-facile-Lilie-Bakery-500x500.jpg',
    categoryId: 4,
  ),
  Product(
    id: 9,
    name: 'Iced Green Tea',
    price: 3.49,
    image: 'https://cdn.loveandlemons.com/wp-content/uploads/2023/06/iced-matcha-latte-500x500.jpg',
    categoryId: 4,
  ),
  Product(
    id: 10,
    name: 'Strawberry Açaí Refresher',
    price: 4.29,
    image: 'https://katerinafaith.com/wp-content/uploads/2025/06/Starbucks-Strawberry-Acai-Refresher-500x500.jpg?crop=1',
    categoryId: 5,
  ),
  Product(
    id: 11,
    name: 'Hot Chocolate',
    price: 3.59,
    image: 'https://bakerbynature.com/wp-content/uploads/2024/01/Hot-Chocolate-3-500x500.jpg',
    categoryId: 6,
  ),
  ];

  static List<Product> getAllProducts() => products;

  static List<Product> getProductsByCategory(int categoryId) {
    return products.where((p) => p.categoryId == categoryId).toList();
  }
}
