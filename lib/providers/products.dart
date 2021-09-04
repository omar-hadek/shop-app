import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/models/http_exeption.dart';
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl: 'assets/images/product1.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl: 'assets/images/product2.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl: 'assets/images/product3.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl: 'assets/images/product4.jpg',
    // ),
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

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavourite,
          }));
      final addedProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(addedProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      try {
        final url = Uri.https(
            'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
            '/products/$id.json');

        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageUrl': product.imageUrl,
            }));
        _items[productIndex] = product;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json');
    try {
      final response = await http.get(url);
      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedProducts.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite: prodData['isFavorite']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExeption(message: 'error accured ');
    }
  }
}
