import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({ Key? key }) : super(key: key);
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('ORDERS'),),
      body: ListView.builder(itemBuilder: (context,i){
        return OrderItem(order:orderData.orders[i]);
      },
      itemCount: orderData.orders.length,
      
      ),
      
    );
  }
}