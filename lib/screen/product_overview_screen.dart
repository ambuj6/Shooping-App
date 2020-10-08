import 'package:flutter/material.dart';
import './../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import './../widgets/badge.dart';
import 'package:provider/provider.dart';
import './../providers/cart.dart';
import './shoping_cart_screen.dart';
import './../providers/products.dart';

enum FilterOption {
  favourites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavourite = false;
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(
        context,
      ).fetchAndSetProduct().then((_) {
        _isLoading = false;
        // Provider.of<Cart>(
        //   context,
        //   listen: false,
        // ).fetchAndSetItem().then((value) => _isLoading = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.favourites) {
                  showFavourite = true;
                } else {
                  showFavourite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show Favourite"),
                value: FilterOption.favourites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOption.all,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(showFavourite),
    );
  }
}
