import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);
  static const routeName = '/product_details';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(routeArgs['title']),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: 300.0,
                child: Image.asset(
                  routeArgs['image'],
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 10.0,
            ),
            Card(
              elevation:5,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(routeArgs['title'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              routeArgs['description'],
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
