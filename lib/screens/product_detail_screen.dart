import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_data.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
//      appBar: AppBar(
//        title: Text(loadedProduct.title),
//      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                style: TextStyle(
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                  fontFamily: "OrbitronRegular",
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20),
              Text(
                "${loadedProduct.price}",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "${loadedProduct.description}",
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 620),
            ]),
          ),
        ],
      ),
    );
  }
}
