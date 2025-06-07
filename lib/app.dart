import 'package:flutter/material.dart';
import 'package:urban_toast/screens/home_screen/home_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  List<Widget> body = const[
      HomeScreen(),
      Icon(Icons.menu),
      Icon(Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(child: body[_currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Menu',
            icon: Icon(Icons.menu),
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
