import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _firebaseUser;
  User? get firebaseUser => _firebaseUser;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProvider() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data();
      } else {
        _userData = null;
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    if (_firebaseUser != null) {
      await _loadUserData(_firebaseUser!.uid);
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    if (_firebaseUser == null) return;
    await _firestore.collection('users').doc(_firebaseUser!.uid).update(updates);
    await refreshUserData();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _firebaseUser = null;
    _userData = null;
    notifyListeners();
  }
}
