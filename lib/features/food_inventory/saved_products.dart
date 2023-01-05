import 'package:flutter/cupertino.dart';

import 'product.dart';

class SavedProducts with ChangeNotifier {
  final List<Product> _products = [];

  SavedProducts() {
    _products.addAll([
      Product('Beef', expiresBy: daysAgo(2)),
      Product('Smoke Fi Taco', expiresBy: daysAgo(3)),
      Product('Bananas', expiresBy: daysAgo(4)),
      Product('Soi soup', expiresBy: daysAgo(6)),
      Product('Smetana', expiresBy: daysAgo(10)),
      Product('Bottle Water', expiresBy: daysAgo(50)),
      Product('Nutella', expiresBy: daysAgo(236)),
    ]);
  }

  List<Product> get all => _products;

  List<Product> get expireSoon => _products.sublist(0, 3);

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  DateTime daysAgo(int days) {
    return DateTime.now().add(Duration(days: days + 1));
  }
}
