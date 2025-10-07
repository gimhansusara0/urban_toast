import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> saveCard({
    required String cardHolder,
    required String cardNumber,
    required String expDate,
    required String csv,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).collection('cards').add({
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expDate': expDate,
      'csv': csv,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<Map<String, dynamic>>> getSavedCards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .get();

    return snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();
  }

  static Future<void> deleteCard(String cardId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .doc(cardId)
        .delete();
  }

  static Future<void> updateCard({
    required String cardId,
    required String cardHolder,
    required String cardNumber,
    required String expDate,
    required String csv,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cards')
        .doc(cardId)
        .update({
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expDate': expDate,
      'csv': csv,
    });
  }
}
