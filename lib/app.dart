import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/auth/auth_provider.dart';
import 'package:urban_toast/screens/cart_screen/cart_screen.dart';
import 'package:urban_toast/screens/home_screen/home_screen.dart';
import 'package:urban_toast/screens/menu_screen/menu_screen.dart';
import 'package:urban_toast/screens/user_account/user_account.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final userId = user?.uid ?? 'guest'; //  fallback if not logged in

    final List<Widget> pages = [
      const HomeScreen(),
      const ProductScreen(),
      CartPage(userId: userId), //  connected to your Firebase user
      const MyUserAccount(),
    ];
    

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() => _currentIndex = newIndex);
        },
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Products', icon: Icon(Icons.coffee)),
          BottomNavigationBarItem(label: 'Cart', icon: Icon(Icons.shopping_cart)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
