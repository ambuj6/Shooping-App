import 'package:flutter/material.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken;
  String userId;
  Products(
    this.authToken,
    this._items,
    this.userId,
  );
  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : "";
    var url =
        'https://shopping-5654e.firebaseio.com/product.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shopping-5654e.firebaseio.com/userFavourite/$userId.json?auth=$authToken';
      final favouriteRespose = await http.get(url);
      final favouriteData = json.decode(favouriteRespose.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach(
        (prodId, prodData) {
          loadedProduct.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavourite: favouriteData == null
                  ? false
                  : favouriteData[prodId] ?? false,
            ),
          );
        },
      );
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get getFavourite {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product getById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product data) async {
    final url =
        'https://shopping-5654e.firebaseio.com/product.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'createrId': userId,
          'title': data.title,
          'price': data.price,
          'description': data.description,
          'imageUrl': data.imageUrl,
        }),
      );
      Product newProduct = Product(
        id: json.decode(response.body)['name'],
        title: data.title,
        price: data.price,
        description: data.description,
        imageUrl: data.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String newId, Product newProduct) async {
    final url =
        'https://shopping-5654e.firebaseio.com/product/$newId.json?auth=$authToken';
    await http.patch(
      url,
      body: json.encode(
        {
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
        },
      ),
    );
    int prodIndex = _items.indexWhere((prod) => prod.id == newId);
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url1 =
        'https://shopping-5654e.firebaseio.com/product/$id.json?auth=$authToken';
    int deleteIndex = _items.indexWhere((element) => element.id == id);
    Product deletedProdect = _items[deleteIndex];
    _items.removeAt(deleteIndex);
    notifyListeners();
    final response = await http.delete(url1);
    if (response.statusCode >= 400) {
      _items.insert(deleteIndex, deletedProdect);
      notifyListeners();
      throw HttpException("Something went wrong");
    }
    deletedProdect = null;
    deleteIndex = null;
  }
}
