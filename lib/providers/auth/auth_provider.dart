// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // simulate API
    _setLoading(false);

    Navigator.pushReplacementNamed(context, '/home'); 
  }

  Future<void> register(BuildContext context) async {
    final first = firstNameController.text.trim();
    final second = secondNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if ([first, second, email, password].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // simulate API
    _setLoading(false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registered Successfully')),
    );
    Navigator.pop(context); // go back to login
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
  }
}
