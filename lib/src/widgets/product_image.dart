import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? url;

  const ProductImage({
    Key? key,
    this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 450,
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            child: url ==null ?
            const Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover,
            ) :
            (url!.startsWith('http') ?
              FadeInImage(
                image: NetworkImage(url!),
                placeholder: const AssetImage('assets/jar-loading.gif'),
                fit: BoxFit.cover,
              ):
              Image.file(
                File(url!),
                fit: BoxFit.cover,
              )
            )
          ),
        )
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    color: Colors.black12,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 5)
      )
    ]
  );
}
