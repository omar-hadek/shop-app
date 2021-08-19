import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Omar Store'),
        ),
      ),
      body: ProductsGrid(),
    );
  }
}


