import 'package:flutter/material.dart';
import '../Moels/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  int count = 0;
  final String token;
  final String userId;
  ProductsProvider(this.token, this.userId, this._productsProviderList);
  List<Product> _productsProviderList = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get productProviderList {
    return _productsProviderList;
  }

  Product isFav(String id) {
    return findById(id);
  }

  Product findById(String id) {
    return productProviderList.firstWhere((prodId) => prodId.id == id);
  }

  Future<void> fetchAndSetData() async {
    final url =
        'https://fluttershopapp-123.firebaseio.com/products.json?auth=$token';
    try {
      final responce = await http.get(url);
      print(responce.statusCode);
      print(json.decode(responce.body));
      final favUrl =
          'https://fluttershopapp-123.firebaseio.com/UserFavourites/.json?auth=$token';
      final responseUserFav = await http.get(favUrl);

      print(responseUserFav.body);
      final resBodyFav =
          json.decode(responseUserFav.body) as Map<String, dynamic>;

      List<Product> temp = [];
      final tempProd = json.decode(responce.body) as Map<String, dynamic>;
      bool tempval;
      int a = 0;
      tempProd.forEach((prodId, prodData) {
        if (resBodyFav == null) {
          tempval = false;
        } else if (resBodyFav[userId][prodId] == false) {
          tempval = false;
        } else {
          tempval = true;
          a += 1;
        }

        temp.add(
          Product(
              id: prodId,
              title: prodData['title'],
              price: prodData['price'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              isFavourite: tempval

              //  resBodyFav == null
              //     ? false
              //     : resBodyFav[userId][prodId] ?? false
              ),
        );
      });
      _productsProviderList = temp;
      count = a;

      notifyListeners();
      print(responce.body);
    } catch (error) {
      print('fetch k eroor m');
      print(error.toString());
      throw error;
    }
  }

  void favCou() {
    int a = 0;
    _productsProviderList.forEach((element) {
      if (element.isFavourite == true) {
        a += 1;

        print(a.toString());
      }
      count = a;
    });

    notifyListeners();
  }

  Future<void> add(Product product) async {
    final url =
        'https://fluttershopapp-123.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));

      print(response.body + 'responce aya');
      print(json.decode(response.body)['name']);
      print(response.statusCode);
      if (response.statusCode == 405) {
        throw Exception(response.statusCode);
      }

      final prod = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );

      _productsProviderList.add(prod);
      notifyListeners();
    } catch (error) {
      print('Product provider cath m');
      print(error.toString() + 'erorr catch k');
      throw error;
    }
  }

  Future<void> update(String id, Product editProduct) async {
    try {
      print(id + 'up');
      final url =
          'https://fluttershopapp-123.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(
        url,
        body: json.encode({
          'title': editProduct.title,
          'price': editProduct.price,
          'description': editProduct.description,
          'imageUrl': editProduct.imageUrl
        }),
      );

      final index = _productsProviderList.indexWhere((prod) => prod.id == id);
      print(index.toString());
      if (index >= 0) {
        _productsProviderList[index] = editProduct;
        print('updated');
        notifyListeners();
      } else {
        print('...');
      }
    } catch (error) {
      print(error.toString());

      throw error();
    }
  }

  Future<void> dleteItem(String id) async {
    final url =
        'https://fluttershopapp-123.firebaseio.com/products/$id.json?auth=$token';
    try {
      await http.delete(url);
      final itemIndex = productProviderList.indexWhere((prod) => prod.id == id);
      productProviderList.removeAt(itemIndex);
      notifyListeners();
    } catch (error) {
      throw error();
    }
  }
}
