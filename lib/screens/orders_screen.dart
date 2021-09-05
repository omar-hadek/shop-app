import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture = Future((){});

  Future _obtainOrdersFuture(){
     return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }
  @override
  void initState() {
     _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ORDERS'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
              width: 200.0,
              child: Row(
                  children: [CircularProgressIndicator(), Text('Loading...')]),
            ));
          } else if (dataSnapShot.error != null) {
            return Center(child: Text('an error occured'));
          } else {
            return Consumer<Orders>(builder: (context,orderData,child){
              return ListView.builder(
              itemBuilder: (context, i) {
                return OrderItem(order: orderData.orders[i]);
              },
              itemCount: orderData.orders.length,
            );
            },
            );
          }
        },
      ),
    );
  }
}
