import 'dart:convert';

import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';

class cartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  cartItem(
      {@required this.id,
      @required this.price,
      @required this.title,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, cartItem> _items = {};

  Map<String, cartItem> get cartItems {
    Map<String, cartItem> item;
    item = _items;
    return item;
  }

  int get lenght {
    // notifyListeners();
    print(_items.length);
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity.roundToDouble();
    });
    return total;
    // notifyListeners();
    print(total.toString());
  }

  int get cartLenght {
    return _items.length;
  }

  void addItems(String productKey, String title, double price) {
    if (_items.containsKey(productKey) == true) {
      print('AAgY IF M');
      _items.update(
          productKey,
          (existingElement) => cartItem(
              id: existingElement.id,
              price: existingElement.price,
              title: existingElement.title,
              quantity: existingElement.quantity + 1));
    } else {
      print('else m');
      _items.putIfAbsent(
          productKey,
          () => cartItem(
              id: DateTime.now().toIso8601String(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }

  bool isInCart(String id) {
    return _items.containsKey(id);
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeItme(String productId) {
    _items.remove(productId);
    print('REMOVE M AAGUA');
    notifyListeners();
  }
}
