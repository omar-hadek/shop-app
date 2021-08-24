import 'package:flutter/material.dart';
import 'package:myshop/widgets/user_products_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user_products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('USER PRODUCTS'),
        actions: [
          IconButton(icon:Icon(Icons.add,size: 20.0,),
          onPressed: (){}),
        ],
      ),
      body: ListView.builder(
        itemCount: productsData.items.length,
        itemBuilder: (context, i) {
          return Column(
            children: [
              UserProductItem(
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
