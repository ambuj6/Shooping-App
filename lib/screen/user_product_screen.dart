import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../providers/products.dart';
import '../widgets/user_product_data.dart';
import './../widgets/app_drawer.dart';
import './../screen/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user-screen';
  Future<void> refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).items;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productData.length,
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[
                UserProductData(
                  productData[i].id,
                  productData[i].title,
                  productData[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
