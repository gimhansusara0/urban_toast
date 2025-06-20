import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/screens/loading/loading_screen.dart';

const Color darkColor = Color(0xFF0D0D0D);
const Color accentColor = Color.fromARGB(255, 182, 107, 63);
const Color darkHighlight = Color.fromARGB(255, 238, 238, 238);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeCategoryProvider()),
        ChangeNotifierProvider(create: (_) => MenuCategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: accentColor,
  primaryColorDark: darkColor,
  cardColor: darkHighlight,
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: accentColor,
  primaryColorDark: darkColor,
  scaffoldBackgroundColor: darkColor,
  cardColor: const Color.fromARGB(255, 36, 36, 36),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: 'monserrat',
    ), // Default font
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Urban Toast',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: LoadingScreen(),
    );
  }
}
