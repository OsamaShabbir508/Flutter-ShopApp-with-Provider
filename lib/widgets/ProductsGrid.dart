import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ProductsProviders.dart';
import '../widgets/ProductItem.dart';
class ProductsGrid extends StatelessWidget {

  
 

  @override
  Widget build(BuildContext context) {
    print('WDGET M AAAYA');
    final productsProviderList=Provider.of<ProductsProvider>(context).productProviderList;
    
    return GridView.builder(
      padding: EdgeInsets.all(15),

      

      
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount
      (
      crossAxisCount: 2,
      childAspectRatio:3/2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 25,
    
    ),

    itemCount: productsProviderList.length,

     itemBuilder:(context,i)=> ChangeNotifierProvider.value(
       
       value: productsProviderList[i],
       
            child: SingleProductItem(
           
             productsProviderList[i].imageUrl,
             productsProviderList[i].title,
             productsProviderList[i].id

           
         ),
     ),
     );
  }
}