import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;
  Orders(
    this.authToken,
    this._orders,
    this.userId,
  );
  List<OrderItem> get getOrder {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://shopping-5654e.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> loadedOrder = [];
    extractedData.forEach((orderId, order) {
      print(order['products']);
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          products: (order['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ),
      );
      print(loadedOrder);
    });

    _orders = loadedOrder;
    notifyListeners();
  }

  Future<void> addOrders(
    List<CartItem> products,
    double total,
  ) async {
    final dateTime = DateTime.now();
    final url =
        'https://shopping-5654e.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': dateTime.toIso8601String(),
            'products': products
                .map((prod) => {
                      'id': prod.id,
                      'title': prod.title,
                      'price': prod.price,
                      'quantity': prod.quantity,
                    })
                .toList(),
          },
        ));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: dateTime,
          products: products),
    );
    notifyListeners();
  }
}
