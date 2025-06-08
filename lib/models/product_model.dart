class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.categoryId,
  });
}
