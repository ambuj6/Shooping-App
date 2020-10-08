import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/orders_screen.dart';
import './screen/product_overview_screen.dart';
import './screen/product_detail_screen.dart';
import './screen/shoping_cart_screen.dart';
import './screen/user_product_screen.dart';
import './screen/edit_product_screen.dart';
import 'screen/login_signup_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './providers/order.dart';

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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(
            auth.token,
            previousOrder == null ? [] : previousOrder.getOrder,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            accentColor: Colors.red,
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : LoginAndSignupScreen(),
                ),
          routes: {
            // ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            ShoppingCartScreen.routeName: (ctx) => ShoppingCartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (cts) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
