import 'package:flutter/material.dart';

class LoginImg extends StatelessWidget {
  const LoginImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        Theme.of(context).brightness == Brightness.dark ? 'assets/images/logo-black.png' : 'assets/images/logo-white.png',
        width: 150,
        height: 150,
      ),
    );
  }
}