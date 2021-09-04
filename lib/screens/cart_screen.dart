import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Cart.dart' show Cart;
import '../providers/orders.dart';
import './orders_screen.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart),
                  ]),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, i) {
                return CartItem(
                    id: cart.items.values.toList()[i].id,
                    productId: cart.items.keys.toList()[i],
                    title: cart.items.values.toList()[i].title,
                    quantity: cart.items.values.toList()[i].quantity,
                    price: cart.items.values.toList()[i].price);
              },
              itemCount: cart.items.length,
            )),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:  (widget.cart.totalAmount <= 0 || _isLoading )? null: () async{
         setState(() {
            _isLoading  = true;
         });
           
        await Provider.of<Orders>(context,listen: false).addOrder(
            widget.cart.items.values.toList(), widget.cart.totalAmount);
          setState(() {
            _isLoading  = false;
         });   
        widget.cart.clear();
        Navigator.of(context).pushNamed(OrdersScreen.routeName);
      },
      child:_isLoading? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                color: Colors.grey,
              )),
          ),

          Text('Loading...')
        ],
      ) :Text(
        'ORDER NOW',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
