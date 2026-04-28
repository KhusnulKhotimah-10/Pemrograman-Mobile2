import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/result_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MaterialApp(
        title: 'AIyam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), // Splash screen pertama
          '/home': (context) => const HomeScreen(),
          '/scan': (context) => const ScanScreen(),
          '/result': (context) => const ResultScreen(),
          '/detail': (context) => const DetailScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
      ),
    );
  }
}
