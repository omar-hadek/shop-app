import 'package:flutter/material.dart';
import 'package:myshop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  const ProductItem(
      {required this.id, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(ProductDetail.routeName,arguments: {
           'id' : id,
           'title': title
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GridTile(
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(title),
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
