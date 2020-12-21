import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Screen/EditProductScreen.dart';
import 'package:shop_app_aftereid/Screen/ProductsOverviewScreen.dart';
import 'package:shop_app_aftereid/providers/orders.dart';
import 'package:shop_app_aftereid/widgets/orderitemWidgets.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '\orderScreen';

//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   var isloading = false;

//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//         isloading = true;
//       });
//       await Provider.of<Order>(context, listen: false).fetchAndSetdata();
//       setState(() {
//         isloading = false;
//       });
//     });

//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    //  final orderData = Provider.of<Order>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
          backgroundColor: Colors.blue,
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
                height: 20,
                width: double.infinity,
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
                    icon: Icon(Icons.shop, color: Colors.blue),
                    onPressed: () {
                      Navigator.of(context).pushNamed(ProductOScreen.routeName);
                    }),
                title: Text('Shop'),
              ),
              Divider(),
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
              ListTile(
                  leading: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditProductScreen.routeName);
                      }),
                  title: Text('Edit And Update')),
            ],
          ),
        ),
        body: FutureBuilder(
            future:
                Provider.of<Order>(context, listen: false).fetchAndSetdata(),
            builder: (context, snapData) {
              if (snapData.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapData.hasError) {
                return Text('An Error Occured');
              } else {
                return Consumer<Order>(
                  builder: (_, order, child) => ListView.builder(
                      itemCount: order.orders.length,
                      itemBuilder: (ctx, i) =>
                          OrderItemWidegts(order.orders[i])),
                );
              }
            }));
  }
}
