import 'package:flutter/cupertino.dart';
import 'package:shop_app_aftereid/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double price;
  final List<cartItem> products;
  final DateTime dateTime;
  OrderItem({this.id, this.price, this.products, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Order(this.token, this.userId);

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchAndSetdata() async {
    final url =
        'https://fluttershopapp-123.firebaseio.com/orders/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      List<OrderItem> temp = [];
      final orderGet = json.decode(response.body) as Map<String, dynamic>;
      orderGet.forEach(
        (orderId, orderData) {
          temp.add(
            OrderItem(
              id: orderId,
              dateTime: DateTime.parse(orderData['dateTime']),
              price: orderData['price'],
              products: (orderData['products'] as List<dynamic>)
                  .map((cart) => cartItem(
                      id: cart['id'].toString(),
                      price: cart['price'],
                      title: cart['title'],
                      quantity: cart['quantity']))
                  .toList(),
            ),
          );
        },
      );
      print('order m');
      _orders = temp;
      print('FETCH KHTAM HOGYA');
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error();
    }
  }

  Future<void> addOrder(List<cartItem> cartProduct, double total) async {
    final url =
        'https://fluttershopapp-123.firebaseio.com/orders/$userId.json?auth=$token';
    DateTime time = DateTime.now();
    try {
      final responce = await http.post(
        url,
        body: json.encode({
          'price': total,
          'dateTime': time.toIso8601String(),
          'products': cartProduct
              .map((cartP) => {
                    'id': cartP.id,
                    'price': cartP.price,
                    'title': cartP.title,
                    'quantity': cartP.quantity
                  })
              .toList()
        }),
      );
      print('order');
      print(responce.body);
      _orders.add(OrderItem(
        id: DateTime.now().toIso8601String(),
        price: total,
        products: cartProduct,
        dateTime: time,
      ));
      print('order k add m');
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error();
    }
  }
}
