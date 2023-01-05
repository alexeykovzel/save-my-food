import 'package:flutter/cupertino.dart';

import 'product.dart';

class Inventory with ChangeNotifier {
  List<Product> _savedProducts = [];

  Inventory() {
    _savedProducts.addAll([
      Product('Beef', expiresBy: daysAgo(2)),
      Product('Smoke Fi Taco', expiresBy: daysAgo(3)),
      Product('Bananas', expiresBy: daysAgo(4)),
      Product('Soi soup', expiresBy: daysAgo(6)),
      Product('Smetana', expiresBy: daysAgo(10)),
      Product('Bottle Water', expiresBy: daysAgo(50)),
      Product('Nutella', expiresBy: daysAgo(236)),
    ]);
  }

  List<Product> get products => _savedProducts;

  List<Product> get expireSoon => _savedProducts.sublist(0, 3);

  set products(List<Product> products) {
    _savedProducts = products;
    notifyListeners();
  }

  void addProduct(Product product) {
    _savedProducts.add(product);
    notifyListeners();
  }
  
  void removeProduct(Product product) {
    _savedProducts.remove(product);
    notifyListeners();
  }

  DateTime daysAgo(int days) {
    return DateTime.now().add(Duration(days: days + 1));
  }
}
