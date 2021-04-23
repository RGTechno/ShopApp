import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String productId;
  final String title;
  final double price;
  final double quantity;

  CartItem({
    this.id,
    this.productId,
    this.imageUrl,
    this.quantity,
    this.price,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteCartItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("ARE YOU SURE?"),
            content: Text("Do You Really Want To Remove This Item From Cart?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
//              backgroundColor: Theme.of(context).primaryColor,
              radius: 35,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
//              child: Padding(
//                padding: const EdgeInsets.all(5),
//                child: FittedBox(
//                  child: Text(
//                    "$price",
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: Colors.black,
//                    ),
//                  ),
//                ),
//              ),
            ),
            title: Text(title),
            subtitle: Text("$quantity x   ${(price * quantity)}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("ARE YOU SURE?"),
                    content: Text(
                        "Do You Really Want To Remove This Item From Cart?"),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text("No"),
                      ),
                      FlatButton(
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .deleteCartItem(productId);
                          Navigator.of(context).pop(true);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
