import 'dart:ui'; // 👈 needed for ImageFilter
import 'package:flutter/material.dart';
import 'package:urban_toast/screens/auth/components/login/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _portraitBuilder(context);
          } else {
            return _landscapeBuilder(context);
          }
        },
      ),
    );
  }
}

Widget _portraitBuilder(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Stack(
    children: [
      // Full background image
      Positioned.fill(
        child: Image.asset(
          'assets/images/zz-login-regis.png',
          fit: BoxFit.cover,
        ),
      ),
      // overlay for contrast
      Positioned.fill(
        child: Container(color: Colors.black.withOpacity(0.55)),
      ),

      // Glassy Login Form
      Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(100),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // blur strength
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.55,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), // transparent white tint
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: SingleChildScrollView(child: LoginForm()),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _landscapeBuilder(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Stack(
    children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/zzz-home-4.jpg',
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        child: Container(color: Colors.black.withOpacity(0.25)),
      ),

      // 🌫️ Glassy Form Section
      Align(
        alignment: Alignment.centerRight,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(80),
            bottomLeft: Radius.circular(80),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: screenWidth * 0.45,
              height: screenHeight * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80),
                  bottomLeft: Radius.circular(80),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(-3, 0),
                  )
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: const SingleChildScrollView(child: LoginForm()),
            ),
          ),
        ),
      ),
    ],
  );
}
