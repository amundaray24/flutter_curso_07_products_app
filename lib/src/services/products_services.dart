import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_curso_07_products_app/src/models/product.dart';


class ProductsServices extends ChangeNotifier {

  final String _baseUrl = 'monkey-solutions-es-firebase-default-rtdb.europe-west1.firebasedatabase.app';
  final String _bucketName = 'monkey-solutions-es-firebase-flutter-course';
  final String _bucketBaseUrl = 'storage.googleapis.com';
  final List<Product> products = [];
  late Product selectedProduct;
  late File? selectedPicture;
  bool isLoading = true;

  ProductsServices() {
    getProducts();
  }

  Future<List<Product>> getProducts () async {
    isLoading = true;
    notifyListeners();

    final response = await _getJsonData('products.json');
    response.forEach((key, value) {
       final product = Product.fromMap(value);
       product.id = key;
       products.add(product);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future createProduct (Product product) async {
    isLoading = true;
    notifyListeners();

    final response = await _postJsonData('products.json',product.toJson());

    product.id = response['name'];
    products.add(product);

    isLoading = false;
    notifyListeners();
  }

  Future modifyProduct (Product product) async {

    isLoading = true;
    notifyListeners();

    await _putJsonData('/products/${product.id}.json',product.toJson());
    products[products.indexWhere((element) => product.id==element.id)] = product;

    isLoading = false;
    notifyListeners();
  }

  void updateSelectedImage(String path) async {
    selectedPicture = File.fromUri(Uri(path: path));
    selectedProduct.picture = path;
    notifyListeners();
  }

  Future<String> uploadImage() async {

    isLoading = true;
    notifyListeners();

    final response = await _postBinaryFile('/upload/storage/v1/b/$_bucketName/o');

    isLoading = false;
    notifyListeners();

    return 'https://storage.googleapis.com/$_bucketName/${response['name']}';
  }

  Future<Map<String,dynamic>> _getJsonData( String endpoint, ) async {

    final url = Uri.https( _baseUrl, endpoint);
    final response = await http.get(url);

    return json.decode(response.body);
  }

  Future<Map<String,dynamic>> _postJsonData( String endpoint, String body ) async {

    final url = Uri.https( _baseUrl, endpoint);
    final response = await http.post(url,body: body);

    return json.decode(response.body);
  }

  Future<Map<String,dynamic>> _putJsonData( String endpoint, String body ) async {

    final url = Uri.https( _baseUrl, endpoint);
    final response = await http.put(url,body: body);

    return json.decode(response.body);
  }

  Future<Map<String,dynamic>> _postBinaryFile( String endpoint) async {

    final Map<String, String> params = {
      'uploadType': 'media',
      'name': selectedPicture!.path.split('/').last,
    };

    final url = Uri.https( _bucketBaseUrl, endpoint, params);

    final response = await http.post(
      url,
      body: await selectedPicture!.readAsBytes()
    );

    return json.decode(response.body);
  }
}