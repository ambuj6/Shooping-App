import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../widgets/app_drawer.dart';
import './../providers/order.dart' show Orders;
import './../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
        ),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: order.getOrder.length,
        itemBuilder: (context, i) => OrderItem(order.getOrder[i]),
      ),
    );
  }
}
