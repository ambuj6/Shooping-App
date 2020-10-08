import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get getCart {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  //Future<void> fetchAndSetItem() async {
  //   final url = 'https://shopping-5654e.firebaseio.com/cart.json';
  //   final Map<String, CartItem> loadedItem = {};
  //   final response = await http.get(url);
  //   final existingProduct = json.decode(response.body) as Map<String, dynamic>;
  //   existingProduct.forEach(
  //     (cartId, cartItem) {
  //       loadedItem.putIfAbsent(
  //           cartId,
  //           () => CartItem(
  //                 id: cartItem['id'],
  //                 title: cartItem['title'],
  //                 price: cartItem['price'],
  //                 quantity: cartItem['quantity'],
  //               ));
  //     },
  //   );
  //   _items = loadedItem;
  // }

  Future<void> addItem(String id, String title, double price) async {
    //final url = 'https://shopping-5654e.firebaseio.com/cart/$id.json';
    final dateTimeId = DateTime.now();
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
      // await http.patch(
      //   url,
      //   body: json.encode(
      //     {
      //       'quantity': _items[id].quantity,
      //     },
      //   ),
      // );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: dateTimeId.toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      // await http.put(url,
      //     body: json.encode({
      //       'id': dateTimeId.toString(),
      //       'title': title,
      //       'price': price,
      //       'quantity': 1,
      //     }));
    }
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    //final url = 'https://shopping-5654e.firebaseio.com/cart/$id.json';
    _items.remove(id);
    // await http.delete(url);
    // notifyListeners();
  }

  Future<void> clear() async {
    // final url = 'https://shopping-5654e.firebaseio.com/cart.json';
    // await http.delete(url);

    _items = {};
    notifyListeners();
  }

  void removeSingleData(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (cartData) => CartItem(
          id: cartData.id,
          title: cartData.title,
          price: cartData.price,
          quantity: cartData.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }
}
