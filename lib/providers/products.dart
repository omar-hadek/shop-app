import 'package:flutter/foundation.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
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

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavorites {
    return items.where((product) => product.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  void addProduct(Product product) {
    final addedProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price);
    _items.add(addedProduct);
    notifyListeners();
  }

  void editProduct(String id,Product product){
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if(productIndex  >=0){
      _items[productIndex] = product;
      notifyListeners();
    }
  }
}
