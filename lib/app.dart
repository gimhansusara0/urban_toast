import 'package:flutter/material.dart';
import 'package:urban_toast/screens/cart_screen/cart.dart';
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
  List<Widget> body = const[
      HomeScreen(),
      ProductScreen(),
      Cart(),
      MyUserAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (int newIndex){
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
            ),
          BottomNavigationBarItem(
            label: 'Products',
            icon: Icon(Icons.coffee),
            ),
            BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon(Icons.shopping_cart),
            ),
         BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
            ),
        ]
      ),
    );
  }
}
