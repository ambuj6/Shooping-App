import 'package:flutter/material.dart';
import 'package:shopping/screen/edit_product_screen.dart';
import 'package:provider/provider.dart';
import './../providers/products.dart';

class UserProductData extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductData(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: id,
                  );
                },
              ),
              IconButton(
                color: Theme.of(context).errorColor,
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                },
              ),
            ],
          ),
        ));
  }
}
