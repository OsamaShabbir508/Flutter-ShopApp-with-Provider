import 'package:flutter/material.dart';
import 'package:shop_app_aftereid/Moels/products.dart';
import 'package:shop_app_aftereid/Screen/productItemDetai.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_aftereid/providers/cart.dart';
import '../providers/ProductsProviders.dart';
import '../providers/Auth.dart';

class SingleProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  SingleProductItem(
    this.imageUrl,
    this.title,
    this.id,
  );
  @override
  Widget build(BuildContext context) {
    //  final authToken = Provider.of<Auth>(context, listen: false);

    final snakeBar = SnackBar(
      backgroundColor: Colors.deepPurple.withOpacity(.8),
      elevation: 30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'Item Added in The Cart',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );

    final productItemLoaded =
        Provider.of<ProductsProvider>(context, listen: false).findById(id);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductItemDetail.nameRoute, arguments: {
                'id': id,
                'title': title,
                'imageUrl': imageUrl,
                'description': productItemLoaded.description
              });
            },
            child: Image.network(
              productItemLoaded.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer2<Product, ProductsProvider>(
              builder: (ctx, products, productsprov, _) => IconButton(
                  color: Colors.red,
                  icon: Icon(products.isFavourite == true
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    products.changePropertyOfIsfavourite(
                        productsprov.token, productsprov.userId);
                    productsprov.favCou();
                  }),
            ),
            title: Text(productItemLoaded.title),
            trailing: Consumer<Cart>(
              builder: (ctx, cart, _) => IconButton(
                  color: Colors.red,
                  icon: Icon(
                    Icons.add_shopping_cart,
                  ),
                  onPressed: () {
                    cart.addItems(
                      productItemLoaded.id,
                      productItemLoaded.title,
                      productItemLoaded.price,
                    );
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      snakeBar,
                    );
                  }),
            ),
            // subtitle: Text(title),
            backgroundColor: Colors.black.withOpacity(.45),
          )),
    );
  }
}
