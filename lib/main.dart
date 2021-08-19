import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '/screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        initialRoute: '/',
        routes: {
          '/' : (context) => ProductOverviewScreen(),
          ProductDetail.routeName : (context)=> ProductDetail(),
        }
      ),
    );
  }
}
