class OrderLine {
  final int productId;
  final String productName;
  final double totalPriceForThisItem; // includes qty & size effects

  OrderLine({
    required this.productId,
    required this.productName,
    required this.totalPriceForThisItem,
  });
}

class Order {
  final String id; // simple string id
  final String userId;
  final DateTime createdAt;
  final List<OrderLine> lines;
  final double subTotal; // sum of line totals

  Order({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.lines,
    required this.subTotal,
  });
}

class PurchaseLog {
  final String id;
  final String userId;
  final DateTime createdAt;
  final double totalAmountSpent;
  final int mostBoughtCategoryId;

  PurchaseLog({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.totalAmountSpent,
    required this.mostBoughtCategoryId,
  });
}
