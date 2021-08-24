import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  const UserProductItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width:100.0,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit,size: 25.0,color: Theme.of(context).primaryColor),
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.delete,size: 25.0,color: Theme.of(context).errorColor),
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}
