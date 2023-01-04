import 'package:flutter/cupertino.dart';

import 'product.dart';

class Profile with ChangeNotifier {
  List<Product> _products = [];

  Profile() {
    _products.addAll([
      Product('Beef', 2),
      Product('Smoke Fi Taco', 3),
      Product('Bananas', 4),
      Product('Soi soup', 6),
      Product('Smetana', 10),
      Product('Bottle Water', 50),
      Product('Nutella', 236),
    ]);
  }

  List<Product> get products => _products;

  List<Product> get expireSoon => _products.sublist(0, 3);

  void deleteProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  set products(List<Product> products) {
    _products = products;
    notifyListeners();
  }
}
