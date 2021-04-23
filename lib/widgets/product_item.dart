import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem({
//    this.id,
//    this.title,
//    this.imageUrl,
//  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              "/prodetail",
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavourite(authData.token, authData.userId);
              },
              color: Colors.redAccent,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, _1) => IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addToCart(product.id, product.title, product.price, 1);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added To Cart"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }
}
