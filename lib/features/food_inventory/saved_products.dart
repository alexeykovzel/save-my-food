import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'product.dart';

class SavedProducts with ChangeNotifier {
  final List<Product> _products = [];

  SavedProducts() {
    _products.addAll([
      Product.byDaysAgo('Beef', days: 2, quantity: 999),
      Product.byDaysAgo('Smoke Fi Taco', days: 3),
      Product.byDaysAgo('Bananas', days: 4),
      Product.byDaysAgo('Soi soup', days: 6),
      Product.byDaysAgo('Smetana', days: 10),
      Product.byDaysAgo('Bottle Water', days: 50),
      Product.byDaysAgo('Nutella', days: 236),
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
}
