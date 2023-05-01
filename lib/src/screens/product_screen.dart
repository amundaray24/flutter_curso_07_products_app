import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_curso_07_products_app/src/services/products_services.dart';
import 'package:flutter_curso_07_products_app/src/providers/product_form_provider.dart';
import 'package:flutter_curso_07_products_app/src/ui/input_decoration.dart';
import 'package:flutter_curso_07_products_app/src/widgets/widgets.dart';


class ProductScreen extends StatelessWidget {

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productsServices = Provider.of<ProductsServices>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(product: productsServices.selectedProduct),
      child: _ProductScreenBody(productsServices: productsServices),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    required this.productsServices,
  });

  final ProductsServices productsServices;

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productsServices.selectedProduct.picture,
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios, size: 25, color: Colors.white))
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {

                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100
                      );
                      if (pickedFile == null) return;

                      productsServices.updateSelectedImage(pickedFile.path);

                    },
                    icon: const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.white)
                  )
                )
              ],
            ),
            const _ProductForm(),
            const SizedBox(height: 100,)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productsServices.isLoading
            ? null
            : () async {

          if (!productFormProvider.isValidForm()) return;

          if (productsServices.selectedPicture!=null) {
            final String imageUrl  = await productsServices.uploadImage();
            productFormProvider.product.picture = imageUrl;
            productsServices.selectedPicture = null;
          }

          if (productFormProvider.product.id!=null) {
            await productsServices.modifyProduct(productFormProvider.product);
          }else {
            await productsServices.createProduct(productFormProvider.product);
          }

          Navigator.pop(context);
        },
        child: productsServices.isLoading
            ? const CircularProgressIndicator(color: Colors.white,)
            : const Icon(Icons.save_rounded),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  const _ProductForm();

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                initialValue: productFormProvider.product.name,
                onChanged: (value) => productFormProvider.product.name = value,
                validator: (value) {
                  if (value==null || value.isEmpty) return 'Requested name';
                  return null;
                },
                decoration: InputDecorations.loginInputDecoration(
                  hint: 'Name of Product',
                  label: 'Name:',
                  color: Colors.blue
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '${productFormProvider.product.price}',
                onChanged: (value) => productFormProvider.product.price = double.tryParse(value)==null ? 0 : double.parse(value),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                validator: (value) {
                  if (value==null || value.isEmpty) return 'Requested price';
                  return null;
                },
                decoration: InputDecorations.loginInputDecoration(
                  hint: '\$150',
                  label: 'Price:',
                  color: Colors.blue
                ),
              ),
              const SizedBox(height: 30,),
              SwitchListTile.adaptive(
                value: productFormProvider.product.available,
                title: const Text('Available'),
                onChanged: productFormProvider.updateAvailability
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 5),
          blurRadius: 5
        )
      ]
    );
  }
}
