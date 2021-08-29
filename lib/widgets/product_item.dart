import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/Cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String imageUrl;
  // final String title;
  // const ProductItem(
  //     {required this.id, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetail.routeName, arguments: {
          'id': product.id,
          'title': product.title,
          'image': product.imageUrl,
          'description': product.description
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GridTile(
          child: Image.asset(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(product.title),
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, 1, product.price);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text('Product added to Cart'),
                    action:  SnackBarAction(
                      label: 'UNDO', onPressed:(){
                        cart.undo(product.id);
                      },),

                  ),
                  
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
