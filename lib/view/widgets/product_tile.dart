// ignore: file_names
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
    );
  }
}
