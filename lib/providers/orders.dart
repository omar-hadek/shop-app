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
  final String? userToken;
  final String? userId;
  Orders(this._orders,this.userToken,this.userId);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    var url
     = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders/$userId.json',{'auth':userToken});


   
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

  Future<void> fetchAndSetOrders() async {
    var url
     = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders/$userId.json',{'auth':userToken});

    print(userToken);
    final response = await http.get(url);
    if(json.decode(response.body) == null){
       return;
    }
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> loadedOrders = [];
    extractedOrders.forEach((id, value) {
      loadedOrders.add(
        OrderItem(
          id: id,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']);
          }).toList(),
          date: DateTime.parse(value['date']),
        ),
      );
    });

    _orders = loadedOrders;
    notifyListeners();
  }
}
