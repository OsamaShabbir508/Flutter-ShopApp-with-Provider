//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Screen/UserProductScreen.dart';
import 'package:shop_app_aftereid/Screen/cartScreen.dart';
import 'package:shop_app_aftereid/Screen/newauthScreen.dart';
import 'package:shop_app_aftereid/Screen/orderScreen.dart';
import 'package:shop_app_aftereid/providers/Auth.dart';
import 'package:shop_app_aftereid/providers/ProductsProviders.dart';
import 'package:shop_app_aftereid/providers/cart.dart';
import 'package:shop_app_aftereid/widgets/ProductItem.dart';
import '../Moels/products.dart';
import '../widgets/ProductsGrid.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class ProductOScreen extends StatefulWidget {
  static const routeName = 'productOsxcreen';

  @override
  _ProductOScreenState createState() => _ProductOScreenState();
}

class _ProductOScreenState extends State<ProductOScreen> {
  var isInit = false;
  @override
  void didChangeDependencies() {
    setState(() {
      isInit = true;
    });
    if (isInit == true) {
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetData()
          .then((value) {
        setState(() {
          isInit = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Online Shoping App'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (ctx, cart, _) => Container(
              margin: EdgeInsets.all(20),
              // padding: EdgeInsets.all(10),

              child: Badge(
                badgeColor: Colors.red,
                shape: BadgeShape.square,
                borderRadius: 20,
                toAnimate: true,
                animationType: BadgeAnimationType.scale,
                badgeContent: Text(cart.lenght.toString(),
                    style: TextStyle(color: Colors.white)),
                child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(cartScreen.routeName);
                    }),
              ),
            ),
          ),
          Consumer<ProductsProvider>(
            builder: (ctx, productcount, _) => Container(
              margin: EdgeInsets.all(25),
              // padding: EdgeInsets.all(10),

              child: Badge(
                badgeColor: Colors.red,
                shape: BadgeShape.square,
                borderRadius: 20,
                toAnimate: true,
                animationType: BadgeAnimationType.scale,
                badgeContent: Text(productcount.count.toString(),
                    style: TextStyle(color: Colors.white)),
                child: Icon(
                  Icons.favorite,
                  size: 25,
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  // shape: BoxShape.circle,

                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      List: [
                        Colors.blue,
                        Colors.purple[300],
                        Colors.purple[200],
                      ])),
              height: 25,
              width: double.infinity,
              //color: Colors.purple,

              alignment: Alignment.center,
              child: Text(
                'Products And Your Orders',
                style: TextStyle(color: Colors.white),
              ),
            )),
            Divider(
              color: Colors.deepPurple,
            ),
            ListTile(
              leading: IconButton(
                  icon: Icon(
                    Icons.shop,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProductOScreen.routeName);
                  }),
              title: Text('Shop'),
            ),
            Divider(
              color: Colors.deepPurple,
            ),
            ListTile(
              leading: IconButton(
                  icon: Icon(
                    Icons.payment,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(OrderScreen.routeName);
                  }),
              title: Text('Orders'),
            ),
            Divider(
              color: Colors.purple,
            ),
            ListTile(
              leading: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(UserProductScreen.routeName);
                  }),
              title: Text('Edit and Update'),
            ),
            ListTile(
              leading: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Provider.of<Auth>(context, listen: false).logout();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AuthScreen(),
                    ));
                  }),
              title: Text('LogOut'),
            ),
          ],
        ),
      ),
      body: isInit == true
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : ProductsGrid(),
    );
  }
}
