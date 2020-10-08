import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/product_detail_screen.dart';

import './../providers/product.dart';
import './../providers/cart.dart';
import './../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cartProduct = Provider.of<Cart>(
      context,
      listen: false,
    );
    final auth = Provider.of<Auth>(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, value, child) => IconButton(
              icon: Icon(
                  value.isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                value.toggleFavourite(
                  auth.token,
                  auth.userId,
                );
              },
            ),
          ),
          trailing: Consumer<Cart>(
            builder: (ctx, cart, child) => IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Item added to the cart",
                    ),
                    duration: Duration(
                      seconds: 2,
                    ),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        cartProduct.removeSingleData(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
