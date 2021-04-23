import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products_data.dart';

class ProductsGrid extends StatelessWidget {
  final bool wished;

  ProductsGrid(this.wished);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =  wished ? productData.wishedItems : productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
//          create: (c) => products[index],
        value: products[index],
          child: ProductItem(
//            id: products[index].id,
//            title: products[index].title,
//            imageUrl: products[index].imageUrl,
          ),
        );
      },
    );
  }
}
