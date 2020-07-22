import 'package:flutter/material.dart';
import './product_screen.dart';

class ProductDetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productDetail =
    return Scaffold(
      appBar: AppBar(
        title: Text(productId),
      ),
      body: Center(
        child: Text("Welcome to new screen"),
      ),
    );
  }
}
