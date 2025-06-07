import 'package:flutter/material.dart';
import 'package:urban_toast/app.dart';

const Color darkColor = Color(0xFF0D0D0D);
const Color accentColor = Color(0xFFBF784E);
const Color darkHighlight = Color(0xFF1F1E1F);

void main() {
  runApp(const MyApp());
}

// Define the light theme
final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: accentColor,
    primaryColorDark: darkColor,
    cardColor: darkHighlight,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: accentColor, foregroundColor: Colors.white)));

// Define the dark theme
final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: accentColor,
    scaffoldBackgroundColor: darkColor,
    cardColor: darkHighlight,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontFamily: 'monserrat'), // Default font
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: accentColor, foregroundColor: Colors.white)));

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
      home: Scaffold(
        body: MainApp(),
      ),
    );
  }
}
