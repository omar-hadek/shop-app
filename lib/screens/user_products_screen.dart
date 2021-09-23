import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_products_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user_products';

  Future<void> _refrechProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true)
        .catchError((error) {
      print(error.toString());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('an error occured'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel))
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('USER PRODUCTS'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                size: 20.0,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      body: FutureBuilder(
        future: _refrechProducts(context),
        builder: (context, snapShotData) {
          if (snapShotData.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapShotData.error != null) {
            return Center(
              child: Text('an error occured'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refrechProducts(context),
              child: Consumer<Products>(
                builder: (context, productsData, _) => ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        UserProductItem(
                            id: productsData.items[i].id,
                            title: productsData.items[i].title,
                            imageUrl: productsData.items[i].imageUrl),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
