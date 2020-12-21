import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Screen/EditProductScreen.dart';
import 'package:shop_app_aftereid/providers/ProductsProviders.dart';
import 'package:shop_app_aftereid/widgets/UserProductWidegts.dart';

class UserProductScreen extends StatelessWidget {
  Future<void> onrefresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetData();
  }

  @override
  static const routeName = '/userProduct';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Products'),
        backgroundColor: Colors.blue.withOpacity(.8),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => onrefresh(context),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Consumer<ProductsProvider>(
                builder: (context, products, _) => ListView.builder(
                      itemCount: products.productProviderList.length,
                      itemBuilder: (ctx, i) => UserProductWidegts(
                        products.productProviderList[i].id,
                        products.productProviderList[i].title,
                        products.productProviderList[i].imageUrl,
                      ),
                    ))),
      ),
    );
  }
}
