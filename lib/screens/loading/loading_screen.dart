import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/screens/auth/register_screen.dart';
import 'package:urban_toast/utils/network_manager.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final network = context.watch<NetworkManager>();
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/zz-landing.png",
              fit: BoxFit.cover,
            ),
          ),

          // Dark gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0), // top darker
                    Colors.black.withOpacity(0), // top darker
                    Colors.black.withOpacity(0.5), // top darker
                    Colors.black.withOpacity(0.8), // bottom slightly lighter
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Main content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    'Zenless Zone Caffee',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.2,
                      fontFamily: 'PoetsenOne',
                      fontSize: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Text(
                    "The best coffee you'll ever taste",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'PlaywriteUSModern',
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor:
                          Theme.of(context).primaryColor, // accent
                      foregroundColor: Colors.white,
                      elevation: 5,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'PoetsenOne',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
