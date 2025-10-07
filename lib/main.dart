import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_toast/app.dart';
import 'package:urban_toast/providers/auth/auth_provider.dart';
import 'package:urban_toast/providers/cart/cart_provider.dart';
import 'package:urban_toast/providers/home_category_provider.dart';
import 'package:urban_toast/providers/ingredients/ingredient_provider.dart';
import 'package:urban_toast/providers/menu_category_provider.dart';
import 'package:urban_toast/providers/orders/orders_provider.dart';
import 'package:urban_toast/providers/product/menu_product_provider.dart';
import 'package:urban_toast/providers/user/user_provider.dart';
import 'package:urban_toast/utils/network_manager.dart';
import 'package:urban_toast/screens/loading/loading_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const Color darkColor = Color.fromARGB(255, 0, 1, 17);
const Color accentColor = Color(0xfffcab0b);
const Color darkHighlight = Color.fromARGB(255, 238, 238, 238);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeCategoryProvider()),
        ChangeNotifierProvider(create: (_) => MenuCategoryProvider()),
        ChangeNotifierProvider(create: (_) => NetworkManager()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MenuProductProvider()),
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
  cardColor: Color.fromARGB(255, 36, 36, 36),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Urban Toast',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/auth',
      routes: {
        '/auth': (_) => const AuthWrapper(),
        '/mainApp': (_) => const MainApp(),
        '/login': (_) => const LoadingScreen(), // can be replaced with your LoginScreen
      },
      builder: (context, child) {
        final network = context.watch<NetworkManager>();
        return Stack(
          children: [child!, ConnectionBanner(isOnline: network.isOnline)],
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.isLoggedIn) {
      return const MainApp();
    }

    return const LoadingScreen(); // or LoginScreen()
  }
}
