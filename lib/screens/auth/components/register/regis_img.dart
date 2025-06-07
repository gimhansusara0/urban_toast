import 'package:flutter/material.dart';

class RegisterImg extends StatelessWidget {
  const RegisterImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
            ? 'assets/images/logo-black.png'
            : 'assets/images/logo-white.png',
            width: 100,
            height: 100,
          ),
    );
  }
}