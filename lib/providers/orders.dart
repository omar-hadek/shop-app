import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.date});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'products': products
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'price': product.price,
                    'quantity': product.quantity,
                  })
              .toList(),
          'date': timestamp.toIso8601String()
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          products: products,
          date: timestamp,
          amount: total),
    );
    notifyListeners();
  }
}
