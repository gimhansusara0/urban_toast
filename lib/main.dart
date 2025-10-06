import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/app.dart';
import 'package:urban_toast/providers/auth/auth_provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';
import 'package:urban_toast/providers/ingredients/ingredient_provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';
import 'package:urban_toast/utils/network_manager.dart';
import 'package:urban_toast/screens/loading/loading_screen.dart';

/// Theme Colors
const Color darkColor = Color.fromARGB(255, 0, 1, 17);
const Color accentColor = Color(0xfffcab0b);
const Color darkHighlight = Color.fromARGB(255, 238, 238, 238);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Auto-detects google-services.json
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeCategoryProvider()),
        ChangeNotifierProvider(create: (_) => MenuCategoryProvider()),
        ChangeNotifierProvider(create: (_) => NetworkManager()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MenuProductProvider()),
        ChangeNotifierProvider(create: (_)  => IngredientProvider())
      ],
      child: const MyApp(),
    ),
  );
}

// Light Theme
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

//  Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: accentColor,
  primaryColorDark: darkColor,
  scaffoldBackgroundColor: darkColor,
  cardColor: const Color.fromARGB(255, 36, 36, 36),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontFamily: 'monserrat',
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
  ),
);

// App Entry
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
      home: const AuthWrapper(), // Handles redirect to home/login
      builder: (context, child) {
        final network = context.watch<NetworkManager>();
        return Stack(
          children: [
            child!,
            ConnectionBanner(isOnline: network.isOnline),
          ],
        );
      },
    );
  }
}

// Auth Wrapper decides if user sees MainApp or LoadingScreen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // While Firebase initializes or user check runs
    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If logged in show home
    if (auth.isLoggedIn) {
      return const MainApp();
    }

    // If not logged in show login / register (LoadingScreen)
    return const LoadingScreen();
  }
}
