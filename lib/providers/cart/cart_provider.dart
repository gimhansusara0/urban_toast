import 'package:flutter/material.dart';
import 'package:urban_toast/models/cart_item.dart';
import 'package:urban_toast/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // We store one CartItem per Product. (Size can be changed inside the cart.)
  // If you want separate lines per size, change key to '${product.id}-${size.name}'
  final Map<int, CartItem> _items = {};
  bool _selectionMode = false;
  final Set<int> _selectedProductIds = {};

  Map<int, CartItem> get items => _items;
  bool get selectionMode => _selectionMode;
  Set<int> get selectedProductIds => _selectedProductIds;

  double get subTotal {
    double t = 0;
    for (final ci in _items.values) {
      t += ci.lineTotal;
    }
    return t;
  }

  bool addProduct(Product product, {ItemSize size = ItemSize.s}) {
    if (_items.containsKey(product.id)) {
      // already in cart
      return false;
    }
    _items[product.id] = CartItem(product: product, qty: 1, size: size);
    notifyListeners();
    return true;
  }

  void incrementQty(int productId) {
    final ci = _items[productId];
    if (ci == null) return;
    ci.qty += 1;
    notifyListeners();
  }

  void decrementQty(int productId) {
    final ci = _items[productId];
    if (ci == null) return;
    if (ci.qty > 1) {
      ci.qty -= 1;
      notifyListeners();
    }
  }

  void changeSize(int productId, ItemSize size) {
    final ci = _items[productId];
    if (ci == null) return;
    ci.size = size;
    notifyListeners();
  }

  Future<bool> removeItem(int productId) async {
    if (!_items.containsKey(productId)) return false;
    _items.remove(productId);
    _selectedProductIds.remove(productId);
    notifyListeners();
    _updateSelectionModeAfterRemoval();
    return true;
  }

  void clearCart() {
    _items.clear();
    _selectedProductIds.clear();
    _selectionMode = false;
    notifyListeners();
  }

  // Selection mode (activated by long-press on an item)
  void enterSelectionMode() {
    if (_selectionMode) return;
    _selectionMode = true;
    notifyListeners();
  }

  void exitSelectionMode() {
    _selectionMode = false;
    _selectedProductIds.clear();
    notifyListeners();
  }

  void toggleSelection(int productId) {
    if (!_selectionMode) return;
    if (_selectedProductIds.contains(productId)) {
      _selectedProductIds.remove(productId);
    } else {
      _selectedProductIds.add(productId);
    }
    notifyListeners();
  }

  Future<void> bulkRemoveSelected() async {
    for (final id in _selectedProductIds.toList()) {
      _items.remove(id);
      _selectedProductIds.remove(id);
    }
    _updateSelectionModeAfterRemoval();
    notifyListeners();
  }

  void _updateSelectionModeAfterRemoval() {
    if (_selectedProductIds.isEmpty) {
      _selectionMode = false;
    }
  }
}
