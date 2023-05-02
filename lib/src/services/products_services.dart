import 'dart:io';
import 'package:flutter_curso_07_products_app/src/models/product.dart';
import 'package:flutter_curso_07_products_app/src/services/base_service.dart';


class ProductsServices extends BaseService {

  final String _baseUrl = 'monkey-solutions-es-firebase-default-rtdb.europe-west1.firebasedatabase.app';
  final String _bucketName = 'monkey-solutions-es-firebase-flutter-course';
  final List<Product> products = [];
  late Product selectedProduct;
  File? selectedPicture;
  bool isLoading = true;

  ProductsServices() : super() {
    getProducts();
  }

  Future<List<Product>> getProducts () async {
    isLoading = true;
    notifyListeners();

    final response = await super.getJsonData(_baseUrl, 'products.json');

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

    final response = await super.postJsonData(_baseUrl, 'products.json',product.toJson());

    product.id = response['name'];
    products.add(product);

    isLoading = false;
    notifyListeners();
  }

  Future modifyProduct (Product product) async {

    isLoading = true;
    notifyListeners();

    await super.putJsonData(_baseUrl, '/products/${product.id}.json',product.toJson());
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

    final response = await super.postBinaryFile(_baseUrl, '/upload/storage/v1/b/$_bucketName/o', selectedPicture!);

    isLoading = false;
    notifyListeners();

    return 'https://storage.googleapis.com/$_bucketName/${response['name']}';
  }
}