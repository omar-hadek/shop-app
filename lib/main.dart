import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/orders.dart';
import '/screens/product_overview_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/cart_screen.dart';
import '/providers/Cart.dart';
import '/providers/products.dart';
import '/providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(null, []),
            update: (context, auth, previourProducts) => Products(auth.token,
                previourProducts == null ? [] : previourProducts.items)),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders([], null,null),
            update: (context, auth, previousOrders) => Orders(
                previousOrders == null ? [] : previousOrders.orders,
                auth.token,
                auth.userId)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductOverviewScreen.routeName: (context) =>
                ProductOverviewScreen(),
            ProductDetail.routeName: (context) => ProductDetail(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
