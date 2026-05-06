import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'screens/main_navigation.dart';
import 'models/adapters.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(StockLogAdapter());
  
  await Hive.openBox('products');
  await Hive.openBox('stock_logs');
  
  // Run the app wrapped in ProviderScope for Riverpod state management
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Modern, clean palette using Teal as the primary seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: child,
          ),
        );
      },
      home: const MainNavigation(),
    );
  }
}
