import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    @required this.dateTime,
    @required this.id,
    @required this.products,
    @required this.amount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url = "https://shopapp-d5042.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    //error handlers
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "price": cp.price,
                    "quantity": cp.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        dateTime: timestamp,
        id: json.decode(response.body)["name"],
        products: cartProducts,
        amount: total,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = "https://shopapp-d5042.firebaseio.com/orders/$userId.json?auth=$authToken";

    final response = await http.get(url);
    var extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.insert(
          0,
          OrderItem(
              dateTime: DateTime.parse(orderData["dateTime"]),
              id: orderId,
              products: (orderData["products"] as List<dynamic>)
                  .map((cartItem) => CartItem(
                        id: cartItem["id"],
                        price: cartItem["price"],
                        title: cartItem["title"],
                        quantity: cartItem["quantity"],
                      ))
                  .toList(),
              amount: orderData["amount"]));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
