import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Orders",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshots) {
          if (dataSnapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemBuilder: (ctx, index) => OrderItem(
                  orderData.orders[index],
                ),
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
      ),
    );
  }
}
