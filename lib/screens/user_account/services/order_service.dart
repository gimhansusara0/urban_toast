import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urban_toast/models/cart_item.dart';

class OrderService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveOrder({
    required Map<int, CartItem> cartItems,
    required double total,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final orderRef = _firestore.collection('orders').doc();
    final orderData = {
      'id': orderRef.id,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'total': total,
      'items': cartItems.values.map((item) {
        return {
          'productId': item.product.id,
          'productName': item.product.name,
          'qty': item.qty,
          'size': item.size.label,
          'unitPrice': item.unitPrice,
          'lineTotal': item.lineTotal,
        };
      }).toList(),
    };

    await orderRef.set(orderData);
  }

  static Future<List<Map<String, dynamic>>> getUserOrders() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((e) {
      final data = e.data();
      data['id'] = e.id;
      return data;
    }).toList();
  }
}
