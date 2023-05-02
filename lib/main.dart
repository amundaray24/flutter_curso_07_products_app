import 'package:flutter/material.dart';
import 'package:flutter_curso_07_products_app/src/services/authentication_service.dart';
import 'package:flutter_curso_07_products_app/src/services/notifications_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_curso_07_products_app/src/screens/screens.dart';
import 'package:flutter_curso_07_products_app/src/services/products_services.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthenticationService()
        )
      ],
      child: const MyApp(),
    );
  }
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
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.blue
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue
        ),
        scaffoldBackgroundColor: Colors.grey[300]
      ),
      scaffoldMessengerKey: NotificationsService.messengerKey,
      initialRoute: 'authenticationLogin',
      routes: {
        'singUp'              : (_) => const SingUpScreen(),
        'login'               : (_) => const LoginScreen(),
        'home'                : (_) => const HomeScreen(),
        'product'             : (_) => const ProductScreen(),
        'authenticationLogin' : (_) => const AuthenticationLoadingScreen(),
      },
    );
  }
}