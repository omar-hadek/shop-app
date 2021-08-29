import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeCartItem(productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void  addItem(String id, String title, int quantity, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (cartItem) => CartItem(
            id: cartItem.id,
            title: cartItem.title,
            quantity: cartItem.quantity + 1,
            price: cartItem.price),
      );
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: quantity,
              price: price));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void undo(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingProduct) => CartItem(
            id: existingProduct.id,
            title: existingProduct.title,
            quantity: existingProduct.quantity - 1,
            price: existingProduct.price),
      );
    }
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
