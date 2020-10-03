import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/app_drawer.dart';
import './../providers/order.dart' show Orders;
import './../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Consumer<Orders>(
                  builder: (context, order, child) => ListView.builder(
                        itemCount: order.getOrder.length,
                        itemBuilder: (context, i) =>
                            OrderItem(order.getOrder[i]),
                      ));
            }
          }),
    );
  }
}
