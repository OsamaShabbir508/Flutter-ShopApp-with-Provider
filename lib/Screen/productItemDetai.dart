import 'dart:ffi';

import 'package:flutter/material.dart';

class ProductItemDetail extends StatelessWidget {
  static const nameRoute = 'ProductsItemDetail';
  @override
  Widget build(BuildContext context) {
    final argu =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    String id = argu['id'];
    String title = argu['title'];
    String imageUrl = argu['imageUrl'];
    String desc = argu['description'];
    // print(imageUrl);
    //print(desc);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                desc,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
