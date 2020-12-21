import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/providers/cart.dart';

class SingleCartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String productId;
  final int quantity;
  SingleCartItem(
      {this.id, this.title, this.price, this.productId, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
          padding: EdgeInsets.only(right: 30),
          margin: EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 1,
          ),
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete_forever)),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Are u sure You Want to Delete?'),
                  content: Text('This Item will be deleted Permanantly'),
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  actions: <Widget>[
                    Consumer<Cart>(
                      builder: (ctx, cart, _) => FlatButton(
                        onPressed: () {
                          cart.removeItme(productId);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.purple,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No', style: TextStyle(color: Colors.white)),
                      color: Colors.purple,
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItme(productId);
      },
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: FittedBox(
                  child: Text(
                '\$${this.price}',
                style: TextStyle(color: Colors.white),
              ))),
          title: Text(this.title),
          subtitle: Text('Total: \$' + (this.price * this.quantity).toString()),
          trailing: FittedBox(
            child: Text(
              this.quantity.toString() + ' X',
            ),
          ),
        ),
      ),
    );
  }
}
