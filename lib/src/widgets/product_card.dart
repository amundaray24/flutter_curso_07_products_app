import 'package:flutter/material.dart';
import 'package:flutter_curso_07_products_app/src/models/product.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    Key? key,
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        width: double.infinity,
        height: 400,
        decoration: _cardDecoration(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              image: product.picture,
            ),
            _ProductDetail(
              id: product.id,
              name: product.name,
            ),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(
                price: product.price,
              )
            ),

            if (!product.available)
              const Positioned(
                  top: 0,
                  left: 0,
                  child: _NotAvailable()
              )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
    ]
  );
}

class _NotAvailable extends StatelessWidget {

  const _NotAvailable();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 130,
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
      child: const FittedBox(
        fit:BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Not Available',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag({
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 130,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.blue,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
      ),
      child: FittedBox(
        fit:BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '$price €',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductDetail extends StatelessWidget {

  final String? id;
  final String name;

  const _ProductDetail({
    this.id,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 70),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold,),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            ),
            if (id!=null)
              Text(
                'Part Number: $id',
                style: const TextStyle(fontSize: 10, color: Colors.white,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              )
          ],
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {

  final String? image;

  const _BackgroundImage({
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: image!=null ? FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(image!),
          fit: BoxFit.cover,
        ) : const Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover,)
      ),
    );
  }
}
