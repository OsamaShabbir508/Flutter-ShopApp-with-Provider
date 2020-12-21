import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/Screen/EditProductScreen.dart';
import 'package:shop_app_aftereid/providers/ProductsProviders.dart';

class UserProductWidegts extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;
  UserProductWidegts(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: id);
                    }),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Provider.of<ProductsProvider>(context, listen: false)
                          .dleteItem(id);
                    }),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.purple,
        )
      ],
    );
  }
}
