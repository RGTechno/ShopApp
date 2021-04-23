import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_data.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
//    final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Your Products",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("/editproduct");
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, index) => UserProductItem(
                              id: productData.items[index].id,
                              title: productData.items[index].title,
                              imageUrl: productData.items[index].imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
