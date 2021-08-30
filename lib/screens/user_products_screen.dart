import 'package:flutter/material.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/user_products_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user_products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('USER PRODUCTS'),
        actions: [
          IconButton(icon:Icon(Icons.add,size: 20.0,),
          onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          }),
        ],
      ),
      body: ListView.builder(
        itemCount: productsData.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              UserProductItem(
                  id: productsData[i].id,
                  title: productsData[i].title,
                  imageUrl: productsData[i].imageUrl),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
