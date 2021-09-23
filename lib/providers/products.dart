import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/models/http_exeption.dart';
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  final String? userToken;
  final String? userId;

  Products(this.userToken, this._items, this.userId);

  List<Product> _items = [];

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
    print(userToken);
    var url;
    if (userToken != null) {
      url = Uri.https(
          'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
          '/products.json',
          {'auth': userToken});
    }

    if (userToken == null) {
      url = Uri.https(
          'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
          '/products.json');
    }
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavourite,
            'creatorId': userId
          }));
      final addedProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
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
        var url;
        if (userToken != null) {
          url = Uri.https(
              'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
              '/products/$id.json',
              {'auth': userToken});
        }

        if (userToken == null) {
          url = Uri.https(
              'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
              '/products/$id.json');
        }

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

  Future<void> fetchAndSetProducts([bool isFilterByUser = false]) async {
    final response;
    var extractedProducts;
    var url;


    if (userToken != null) {
      url = isFilterByUser? Uri.parse(
          'https://shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$userToken&orderBy="creatorId"&equalTo="$userId"'):
          Uri.parse(
          'https://shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$userToken');

          // url = Uri.https(
          // 'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
          // '/products.json', {'auth': userToken});
      response = await http.get(url);
      extractedProducts = json.decode(response.body) as Map<String, dynamic>;
    }
    url = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/userFavirites/$userId.json',
        {'auth': userToken});

    final favoriteResponse = await http.get(url);
    var favoriteData = json.decode(favoriteResponse.body);
    try {
      final List<Product> loadedProducts = [];
      extractedProducts.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite:
                favoriteData == null ? false : favoriteData[userId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    var url;
    if (userToken != null) {
      url = Uri.https(
          'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
          '/products/$id.json',
          {'auth': userToken});
    }

    if (userToken == null) {
      url = Uri.https(
          'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
          '/products/$id.json');
    }
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
