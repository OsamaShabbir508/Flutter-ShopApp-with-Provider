import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/providers/cart.dart';
import 'package:shop_app_aftereid/providers/orders.dart';
import 'package:intl/intl.dart';
class OrderItemWidegts extends StatelessWidget {
final OrderItem orderItem;
OrderItemWidegts(this.orderItem);

  @override
  Widget build(BuildContext context) {
    final double amount=Provider.of<Cart>(context,listen: false).totalAmount;
    return Card(margin: EdgeInsets.all(7),
    elevation: 10,

      child: ListTile(
leading: Icon(Icons.done_all,color: Colors.red),
title: Text('\$${orderItem.price.toStringAsFixed(3)}',style: TextStyle(
  color: Colors.deepPurple,
),),
subtitle:Text( DateFormat('dd MM yyyy hh:mm').format(orderItem.dateTime)),
trailing: Icon(Icons.expand_more,color: Colors.red,),


      ),
      
    );
  }
}