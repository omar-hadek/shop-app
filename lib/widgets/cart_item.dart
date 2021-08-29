import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  const CartItem(
      {required this.id,
      required this.productId,
      required this.title,
      required this.quantity,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (context){
           return AlertDialog(
             title: Text('are you sure for deleting this item ?'),
             content: Text('are you sure you want to delete this item from the cart ?') ,
             actions: [
               FlatButton(
                 child: Text('NO'),
                 onPressed :(){
                   Navigator.of(context).pop(false);
                 }
               ),
               FlatButton(
                 child: Text('YES'),
                 onPressed :(){
                   Navigator.of(context).pop(true);
                 }
               ),

             ],
           );
        });
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeCartItem(productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40.0,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text('\$${price.toStringAsFixed(2)}')),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text('Total : ${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
