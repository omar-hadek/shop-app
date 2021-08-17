import 'package:flutter/material.dart';
import 'package:myshop/widgets/product_item.dart';
import '../models/product.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'assets/images/product1.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl: 'assets/images/product2.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'assets/images/product3.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'assets/images/product4.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Omar Store'),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
          itemCount: loadedProducts.length,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return ProductItem(
                id: loadedProducts[index].id,
                imageUrl: loadedProducts[index].imageUrl,
                title: loadedProducts[index].title);
          }),
    );
  }
}
