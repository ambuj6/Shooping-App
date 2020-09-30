import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart' show Cart;
import './../widgets/cart_item.dart';
import './../providers/order.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            elevation: 5,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      "Order Now",
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrders(
                        cart.getCart.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                    },
                  ),
                ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, i) => CartItem(
                cart.getCart.values.toList()[i].id,
                cart.getCart.keys.toList()[i],
                cart.getCart.values.toList()[i].title,
                cart.getCart.values.toList()[i].price,
                cart.getCart.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
