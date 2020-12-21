import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Moels/products.dart';
//import 'package:shop_app_aftereid/Screen/4.1%20auth_screen.dart.dart';
import 'package:shop_app_aftereid/Screen/EditProductScreen.dart';
import 'package:shop_app_aftereid/Screen/UserProductScreen.dart';
import 'package:shop_app_aftereid/Screen/cartScreen.dart';
import 'package:shop_app_aftereid/Screen/orderScreen.dart';
import 'package:shop_app_aftereid/Screen/productItemDetai.dart';
import 'package:shop_app_aftereid/providers/Auth.dart';
import 'package:shop_app_aftereid/providers/ProductsProviders.dart';
import 'package:shop_app_aftereid/providers/cart.dart';
import 'package:shop_app_aftereid/providers/orders.dart';
import './Screen/ProductsOverviewScreen.dart';
import './Screen/EditProductScreen.dart';
import 'Screen/newauthScreen.dart';
import './Screen/UserProductScreen.dart';
//import './Screen/4.1 auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        //  ChangeNotifierProvider.value(
        //   value: ProductsProvider(),
        // ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider(null, null, []),
          update: (ctx, auth, previousProduct) => ProductsProvider(
              auth.token(),
              auth.userId,
              // previousProduct == null
              //     ? []
              //     :
              previousProduct.productProviderList),
        ),

        //  ProxyProvider<Auth,Product>(update: (ctx,auth,prevoius)=>product)
        // ProxyProvider<Auth, ProductsProvider>(
        //   update: (context, auth, previousProduct) => ProductsProvider(
        //       auth.token(),
        //       previousProduct == null
        //           ? []
        //           : previousProduct.productProviderList),
        // ),

        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order(null, null),
          update: (ctx, auth, previousState) =>
              Order(auth.token(), auth.userId),
        )
      ],

      //create:(ctx)=> ProductsProvider() ,
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Dealy Meals',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.token() == null ? AuthScreen() : ProductOScreen(),
          //ProductOScreen(),
          routes: {
            ProductItemDetail.nameRoute: (ctx) => ProductItemDetail(),
            cartScreen.routeName: (ctx) => cartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            ProductOScreen.routeName: (ctx) => ProductOScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            AuthScreen.routeName: (_) => AuthScreen()
          },
        ),
      ),
    );
  }
}
