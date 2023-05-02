import 'package:flutter/material.dart';
import 'package:flutter_curso_07_products_app/src/screens/screens.dart';
import 'package:flutter_curso_07_products_app/src/services/authentication_service.dart';
import 'package:provider/provider.dart';

class AuthenticationLoadingScreen extends StatelessWidget {

  const AuthenticationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authenticationService = Provider.of<AuthenticationService>(context,listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder (
          future: authenticationService.validateToken(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            if (!asyncSnapshot.hasData) return const CircularProgressIndicator(color: Colors.blue,);
            if (asyncSnapshot.data == '') {
              Future.microtask(() =>
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => const LoginScreen(),
                    transitionDuration: const Duration(seconds: 0)
              )));
            } else {
              Future.microtask(() =>
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (_,__,___) => const HomeScreen(),
                    transitionDuration: const Duration(seconds: 0)
              )));
            }
            return Container();
          },
        ),
      ),
    );
  }
}