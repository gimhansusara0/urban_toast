import 'package:urban_toast/models/product_model.dart';

enum ItemSize { s, m, l }

extension ItemSizeLabel on ItemSize {
  String get label {
    switch (this) {
      case ItemSize.s: return 'S';
      case ItemSize.m: return 'M';
      case ItemSize.l: return 'L';
    }
  }
}

class CartItem {
  final Product product;
  int qty;
  ItemSize size;

  CartItem({
    required this.product,
    this.qty = 1,
    this.size = ItemSize.s,
  });

  // Size pricing rule:
  // S = base price
  // M = base + 50
  // L = base + 100
  double get unitPrice {
    final add = switch (size) {
      ItemSize.s => 0.0,
      ItemSize.m => 50.0,
      ItemSize.l => 100.0,
    };
    return product.price + add;
  }

  double get lineTotal => unitPrice * qty;
}
