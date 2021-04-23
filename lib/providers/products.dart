import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
    @required this.description,
    this.isFavourite = false,
  });

  void toggleFavourite(String token, String userId) async {
    var oldStatus = isFavourite;
    final url =
        "https://shopapp-d5042.firebaseio.com/userFavourites/$userId/$id.json?auth=$token";
    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      notifyListeners();
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
