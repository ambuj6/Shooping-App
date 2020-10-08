import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../screen/orders_screen.dart';
import './../screen/user_product_screen.dart';

import './../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello friends"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              print("Clicked");
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Your Orders"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                OrderScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Product"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                UserProductScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log out"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
        ],
      ),
    );
  }
}
