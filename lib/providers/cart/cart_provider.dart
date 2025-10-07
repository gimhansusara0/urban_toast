import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_toast/models/cart_item.dart';
import 'package:urban_toast/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  bool _selectionMode = false;
  final Set<int> _selectedProductIds = {};

  CartProvider() {
    _listenToAuthChanges(); // automatically load/clear on login/logout
  }

  Map<int, CartItem> get items => _items;
  bool get selectionMode => _selectionMode;
  Set<int> get selectedProductIds => _selectedProductIds;

  double get subTotal => _items.values.fold(0, (t, ci) => t + ci.lineTotal);

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _cartListener;


  // AUTH STATE CHANGE load/clear

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      await _cartListener?.cancel();
      if (user == null) {
        _items.clear();
        notifyListeners();
        return;
      }
      await loadCartFromFirestore(live: true); // live sync
    });
  }


  // ADD PRODUCT

  bool addProduct(Product product, {ItemSize size = ItemSize.s}) {
    if (_items.containsKey(product.id)) return false;

    final cartItem = CartItem(product: product, qty: 1, size: size);
    _items[product.id] = cartItem;
    notifyListeners();

    _saveToFirestore(cartItem);
    return true;
  }


  // QTY CHANGE

  void incrementQty(int productId) {
    final ci = _items[productId];
    if (ci == null) return;
    ci.qty++;
    notifyListeners();
    _updateFirestore(ci);
  }

  void decrementQty(int productId) {
    final ci = _items[productId];
    if (ci == null) return;
    if (ci.qty > 1) {
      ci.qty--;
      notifyListeners();
      _updateFirestore(ci);
    }
  }

  // SIZE CHANGE

  void changeSize(int productId, ItemSize size) {
    final ci = _items[productId];
    if (ci == null) return;
    ci.size = size;
    notifyListeners();
    _updateFirestore(ci);
  }


  // REMOVE ITEM

  Future<bool> removeItem(int productId) async {
    if (!_items.containsKey(productId)) return false;
    _items.remove(productId);
    _selectedProductIds.remove(productId);
    notifyListeners();
    _updateSelectionModeAfterRemoval();
    await _removeFromFirestore(productId);
    return true;
  }


  // CLEAR CART

  Future<void> clearCart() async {
    _items.clear();
    _selectedProductIds.clear();
    _selectionMode = false;
    notifyListeners();
    await _clearFirestore();
  }


  // SELECTION MODE

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
      await _removeFromFirestore(id);
      _selectedProductIds.remove(id);
    }
    _updateSelectionModeAfterRemoval();
    notifyListeners();
  }

  void _updateSelectionModeAfterRemoval() {
    if (_selectedProductIds.isEmpty) _selectionMode = false;
  }


  // FIRESTORE SYNC HELPERS


  Future<void> _saveToFirestore(CartItem item) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(item.product.id.toString())
          .set({
        'productId': item.product.id,
        'name': item.product.name,
        'categoryId': item.product.categoryId,
        'qty': item.qty,
        'size': item.size.label,
        'unitPrice': item.unitPrice,
        'lineTotal': item.lineTotal,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving to Firestore: $e');
    }
  }

  Future<void> _updateFirestore(CartItem item) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(item.product.id.toString())
          .update({
        'qty': item.qty,
        'size': item.size.label,
        'lineTotal': item.lineTotal,
        'unitPrice': item.unitPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating Firestore: $e');
    }
  }

  Future<void> _removeFromFirestore(int productId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId.toString())
          .delete();
    } catch (e) {
      debugPrint('Error removing from Firestore: $e');
    }
  }

  Future<void> _clearFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint('Error clearing Firestore cart: $e');
    }
  }


  // LOAD CART

  Future<void> loadCartFromFirestore({bool live = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      // cancel previous listener if exists
      await _cartListener?.cancel();

      if (live) {
        _cartListener = cartRef.snapshots().listen((snapshot) {
          _items.clear();
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final size = ItemSize.values.firstWhere(
              (s) => s.label == data['size'],
              orElse: () => ItemSize.s,
            );
            final product = Product(
              id: data['productId'],
              name: data['name'],
              price: (data['unitPrice'] as num).toDouble(),
              image: '',
              categoryId: data['categoryId'],
              description: '',
              rating: 0.0,
            );
            _items[product.id] = CartItem(
              product: product,
              qty: data['qty'] ?? 1,
              size: size,
            );
          }
          notifyListeners();
        });
      } else {
        final snapshot = await cartRef.get();
        _items.clear();
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final size = ItemSize.values.firstWhere(
            (s) => s.label == data['size'],
            orElse: () => ItemSize.s,
          );
          final product = Product(
            id: data['productId'],
            name: data['name'],
            price: (data['unitPrice'] as num).toDouble(),
            image: '',
            categoryId: data['categoryId'],
            description: '',
            rating: 0.0,
          );
          _items[product.id] = CartItem(
            product: product,
            qty: data['qty'] ?? 1,
            size: size,
          );
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading Firestore cart: $e');
    }
  }

  @override
  void dispose() {
    _cartListener?.cancel();
    super.dispose();
  }
}
