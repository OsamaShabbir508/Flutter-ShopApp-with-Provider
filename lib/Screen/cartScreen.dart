import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Screen/orderScreen.dart';
import 'package:shop_app_aftereid/providers/orders.dart';
import 'package:shop_app_aftereid/widgets/singleCartItem.dart';
import '../providers/cart.dart';

class cartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';

  @override
  _cartScreenState createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.blue,
      ),
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ))
          : Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Consumer<Cart>(
                              builder: (ctx, cart, _) => Chip(
                                    label: Text(
                                      '\$${cart.totalAmount.toStringAsFixed(3)}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.blue,
                                  )),
                          Spacer(),
                          Consumer<Cart>(
                            builder: (ctx, cart, _) => FlatButton(
                              onPressed: () async {
                                try {
                                  print('caert item');
                                  setState(() {
                                    isloading = true;
                                  });
                                  await Provider.of<Order>(context,
                                          listen: false)
                                      .addOrder(cart.cartItems.values.toList(),
                                          cart.totalAmount);
                                  setState(() {
                                    isloading = false;
                                  });
                                  print('cart item');
                                  //  await Provider.of<Order>(context,
                                  //      listen: false)
                                  //     .fetchAndSetdata();
                                  cart.clearCart();
                                  Navigator.of(context)
                                      .pushNamed(OrderScreen.routeName);
                                } catch (error) {} finally {
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
                              child: Text(
                                'Order Now',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 15,
                  ),
                  child: Consumer<Cart>(
                      builder: (ctx, cart, _) => ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: cart.cartLenght,
                          itemBuilder: (ctx, i) => SingleCartItem(
                                id: cart.cartItems.values.toList()[i].id,
                                price: cart.cartItems.values.toList()[i].price,
                                quantity:
                                    cart.cartItems.values.toList()[i].quantity,
                                title: cart.cartItems.values.toList()[i].title,
                                productId: cart.cartItems.keys.toList()[i],
                              ))),
                ))
              ],
            ),
    );
  }
}
