import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screen/orders_screen.dart';
import './screen/product_overview_screen.dart';
import './screen/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screen/shoping_cart_screen.dart';
import './providers/order.dart';
import './screen/user_product_screen.dart';
import './screen/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: Colors.red,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          ShoppingCartScreen.routeName: (ctx) => ShoppingCartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (cts) => EditProductScreen(),
        },
      ),
    );
  }
}
