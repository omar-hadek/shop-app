import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false });


  Future<void> toggleFavoriteStatus() async{
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
     final url = Uri.https(
        'shop-app-c4357-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id.json');
        try{
        final response  = await http.patch(url,body:json.encode({
          'isFavorite':isFavourite,
        }));
        if(response.statusCode >= 400){
           isFavourite = oldStatus;
          notifyListeners();
        }
        }catch(error){
          isFavourite = oldStatus;
          notifyListeners();
        }
  }
}
