import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_data.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';

enum FilterOptions {
  Wished,
  All,
}

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _showWished = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var _init = true;
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "MYSHOP",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Wished) {
                  _showWished = true;
                } else {
                  _showWished = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("WishList"),
                value: FilterOptions.Wished,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.cartLength.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed("/cart");
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showWished),
    );
  }
}
