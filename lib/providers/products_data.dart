import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './products.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  var showOnlyFavs = false;

  List<Product> get wishedItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  String cartProductImage(String id){
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if(productIndex!=null){
      return _items[productIndex].imageUrl;
    }
    return "https://www.udemy.com/staticx/udemy/images/v6/logo-coral-light.svg";

  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp-d5042.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shopapp-d5042.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://shopapp-d5042.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "isFavourite": product.isFavourite,
          "creatorId": userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        price: product.price,
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.description,
      );
      _items.insert(0, newProduct);
//    _items.add(value);
      print(json.decode(response.body)["name"]);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    var prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://shopapp-d5042.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(
        url,
        body: json.encode({
          "title": updatedProduct.title,
          "price": updatedProduct.price,
          "description": updatedProduct.description,
          "imageUrl": updatedProduct.imageUrl,
        }),
      );
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    var existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final url =
        "https://shopapp-d5042.firebaseio.com/products/$id.json?auth=$authToken";
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could Not Delete Product");
    }
    existingProduct = null;
  }
}
