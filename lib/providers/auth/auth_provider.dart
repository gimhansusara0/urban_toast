import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_toast/main.dart'; 

class AuthProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  User? _currentUser;
  User? get currentUser => _currentUser;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _listenToAuthChanges();
  }

  //  Listen to login/logout state changes
  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) async {
      _currentUser = user;
      _isLoggedIn = user != null;

      if (user != null) {
        await _fetchUserData(user.uid);
      } else {
        _userData = null;
      }

      notifyListeners();
    });
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get(
        const GetOptions(source: Source.cache),
      );

      if (doc.exists) {
        _userData = doc.data();
      } else {
        final onlineDoc = await _firestore.collection('users').doc(uid).get();
        if (onlineDoc.exists) _userData = onlineDoc.data();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
    notifyListeners();
  }

  // Login
  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack(context, 'Please fill all fields');
      return;
    }

    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _showSnack(context, 'Login successful');

      // Navigate to MainApp after login
      navigatorKey.currentState?.pushReplacementNamed('/mainApp');
    } on FirebaseAuthException catch (e) {
      _showSnack(context, _firebaseError(e));
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<void> register(BuildContext context) async {
    final first = firstNameController.text.trim();
    final second = secondNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if ([first, second, email, password].any((e) => e.isEmpty)) {
      _showSnack(context, 'Please fill all fields');
      return;
    }

    _setLoading(true);
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'firstName': first,
        'secondName': second,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSnack(context, 'Registered successfully');

      // Redirect to MainApp
      navigatorKey.currentState?.pushReplacementNamed('/mainApp');
    } on FirebaseAuthException catch (e) {
      _showSnack(context, _firebaseError(e));
    } finally {
      _setLoading(false);
    }
  }

  //  Update profile
  Future<void> updateProfile(
    BuildContext context, {
    required String firstName,
    required String secondName,
  }) async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'firstName': firstName,
        'secondName': secondName,
      });

      _userData?['firstName'] = firstName;
      _userData?['secondName'] = secondName;

      _showSnack(context, 'Profile updated');
    } catch (e) {
      _showSnack(context, 'Failed to update profile: $e');
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _userData = null;
    _isLoggedIn = false;
    notifyListeners();

    //  Redirect to login/loading
    navigatorKey.currentState?.pushReplacementNamed('/login');
  }

  // HELPERS 

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _firebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user is disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password too weak';
      default:
        return e.message ?? 'Something went wrong';
    }
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
  }
}
