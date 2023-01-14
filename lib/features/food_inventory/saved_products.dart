import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'product.dart';

class SavedProducts with ChangeNotifier {
  final List<Product> _products = [];
  
  SavedProducts() {
    _products.addAll([
      Product('Beef', expiresBy: daysAgo(2), quantity: 999),
      Product('Smoke Fi Taco', expiresBy: daysAgo(3)),
      Product('Bananas', expiresBy: daysAgo(4)),
      Product('Soi soup', expiresBy: daysAgo(6)),
      Product('Smetana', expiresBy: daysAgo(10)),
      Product('Bottle Water', expiresBy: daysAgo(50)),
      Product('Nutella', expiresBy: daysAgo(236)),
    ]);
  }

  List<Product> get all => _products;

  List<Product> get expireSoon {
    return _products.sublist(0, min(_products.length, 3));
  }

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void swap(Product product, Product newProduct) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == product.id) {
        _products[i] = newProduct;
        notifyListeners();
      }
    }
  }

  DateTime daysAgo(int days) {
    return DateTime.now().add(Duration(days: days + 1));
  }
}
