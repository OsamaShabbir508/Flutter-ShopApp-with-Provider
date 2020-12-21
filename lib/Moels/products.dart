import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/providers/Auth.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> changePropertyOfIsfavourite(String token, String userId) async {
    print(token);
    print(userId);

    isFavourite = !isFavourite;
    var oldStatus = !isFavourite;
    notifyListeners();
    try {
      final url =
          'https://fluttershopapp-123.firebaseio.com/UserFavourites/$userId/$id.json?auth=$token';
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      print(response.body);
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
      throw error();
    }
  }
}
