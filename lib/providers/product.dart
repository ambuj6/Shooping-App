import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false});

  Future<void> toggleFavourite(String token, String userId) async {
    final url =
        'https://shopping-5654e.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';
    isFavourite = !isFavourite;
    notifyListeners();
    final response = await http.put(
      url,
      body: json.encode(
        isFavourite,
      ),
    );
    if (response.statusCode >= 400) {
      print(response.body);
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }
}
