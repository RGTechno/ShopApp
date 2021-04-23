import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final double quantity;

  CartItem({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartLength {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void deleteCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (exCartItem) => CartItem(
          id: exCartItem.id,
          price: exCartItem.price,
          title: exCartItem.title,
          quantity: exCartItem.quantity - 1,
        ),
      );
    }
    else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addToCart(
      String productId, String title, double price, double quantity) {
    if (_items.containsKey(productId)) {
      //change Quantity;
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
