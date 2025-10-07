import 'dart:ui'; // 👈 Needed for ImageFilter
import 'package:flutter/material.dart';
import 'package:urban_toast/screens/auth/components/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
      // overlay for better contrast
      Positioned.fill(
        child: Container(color: Colors.black.withOpacity(0.55)),
      ),

      // Glassy Register Form
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
              height: screenHeight * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
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
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: SingleChildScrollView(child: RegisterForm()),
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
      // Background image
      Positioned.fill(
        child: Image.asset(
          'assets/images/zzz-home-4.jpg',
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        child: Container(color: Colors.black.withOpacity(0.55)),
      ),

      // Glassy Register Form on right
      Align(
        alignment: Alignment.centerRight,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(80),
            bottomLeft: Radius.circular(80),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur strength
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
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: const SingleChildScrollView(child: RegisterForm()),
            ),
          ),
        ),
      ),
    ],
  );
}
