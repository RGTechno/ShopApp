import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/products_data.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final productData = Provider.of<Products>(context,listen: false);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "CART",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 15,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "OrbitronRegular",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Serif",
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 10,
                  ),
                  SizedBox(width: 10),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartLength,
              itemBuilder: (ctx, index) => CartItem(
//                imageUrl: ,
              imageUrl: productData.cartProductImage(cart.items.keys.toList()[index]),
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required bool isLoading,
  }) : _isLoading = isLoading, super(key: key);

  final Cart cart;
  final bool _isLoading;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.black12,
      child: _isLoading ? CircularProgressIndicator() : Text(
        "Place Order",
        style: TextStyle(
          fontFamily: "OrbitronBold",
        ),
      ),
      onPressed: widget.cart.totalAmount <= 0 || _isLoading ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrders(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        );
        widget.cart.clear();
        setState(() {
          _isLoading = false;
        });
      },
    );
  }
}
