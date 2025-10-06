import 'package:flutter/material.dart';
import 'package:urban_toast/models/cart_item.dart';
import 'package:urban_toast/models/order.dart';

class OrdersProvider extends ChangeNotifier {
  // Keep orders & logs per user
  final Map<String, List<Order>> _ordersByUser = {};
  final Map<String, List<PurchaseLog>> _logsByUser = {};

  List<Order> ordersForUser(String userId) => _ordersByUser[userId] ?? [];
  List<PurchaseLog> logsForUser(String userId) => _logsByUser[userId] ?? [];

  /// Build and add an order from the current cart items
  /// Returns the created Order
  Order addOrderFromCart({
    required String userId,
    required Map<int, CartItem> cartItems,
  }) {
    final lines = <OrderLine>[];
    final categoryHitCount = <int, int>{};
    double total = 0;

    for (final ci in cartItems.values) {
      // create order line with *total for this item* (qty & size included)
      final line = OrderLine(
        productId: ci.product.id,
        productName: ci.product.name,
        totalPriceForThisItem: ci.lineTotal,
      );
      lines.add(line);
      total += ci.lineTotal;

      // track category counts to compute "most bought category id"
      categoryHitCount.update(ci.product.categoryId, (v) => v + ci.qty, ifAbsent: () => ci.qty);
    }

    final mostBoughtCategoryId = _computeMostBoughtCategory(categoryHitCount);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      createdAt: DateTime.now(),
      lines: lines,
      subTotal: total,
    );

    // save order
    _ordersByUser.putIfAbsent(userId, () => []);
    _ordersByUser[userId]!.add(order);

    // create a purchase log entry
    final log = PurchaseLog(
      id: 'log_${order.id}',
      userId: userId,
      createdAt: DateTime.now(),
      totalAmountSpent: total,
      mostBoughtCategoryId: mostBoughtCategoryId,
    );

    _logsByUser.putIfAbsent(userId, () => []);
    _logsByUser[userId]!.add(log);

    notifyListeners();
    return order;
  }

  int _computeMostBoughtCategory(Map<int, int> counts) {
    int bestCat = counts.isEmpty ? -1 : counts.keys.first;
    int bestCount = -1;

    counts.forEach((cat, count) {
      if (count > bestCount) {
        bestCat = cat;
        bestCount = count;
      }
    });

    return bestCat;
  }
}
