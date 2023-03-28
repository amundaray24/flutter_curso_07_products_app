import 'package:flutter/material.dart';
import 'package:flutter_curso_07_products_app/src/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products App',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300]
      ),
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'home' : (_) => const HomeScreen()
      },
    );
  }
}