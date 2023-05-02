import 'package:flutter/material.dart';
import 'package:flutter_curso_07_products_app/src/models/product.dart';
import 'package:flutter_curso_07_products_app/src/screens/screens.dart';
import 'package:flutter_curso_07_products_app/src/services/authentication_service.dart';
import 'package:flutter_curso_07_products_app/src/services/products_services.dart';
import 'package:flutter_curso_07_products_app/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productsServices = Provider.of<ProductsServices>(context);
    final authenticationService = Provider.of<AuthenticationService>(context);

    if (productsServices.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Products')),
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            authenticationService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: productsServices.products.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            productsServices.selectedProduct = productsServices.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: productsServices.products[index])
        )
      ),
      floatingActionButton: FloatingActionButton (
        child: const Icon(Icons.add),
        onPressed: (){
          productsServices.selectedProduct = Product(
            name: '',
            available: false,
            price: 0.0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
