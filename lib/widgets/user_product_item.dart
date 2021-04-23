import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_data.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  UserProductItem({
    this.id,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/editproduct", arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to Delete",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
