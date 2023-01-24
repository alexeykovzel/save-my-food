import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'product.dart';
import 'package:save_my_food/features/notifications/notification_scheduler.dart';

class SavedProducts with ChangeNotifier {
  final List<Product> _products = [];

  SavedProducts() {
    NotificationScheduler.init(_products);
    _products.addAll([
      Product.byDaysAgo('Dolphin', daysAgo: 2, quantity: 1),
      Product.byDaysAgo('Bread', daysAgo: 3),
      Product.byDaysAgo('Bananas', daysAgo: 5, quantity: 5),
      Product.byDaysAgo('Soi soup', daysAgo: 6),
      Product.byDaysAgo('Cheese', daysAgo: 10),
      Product.byDaysAgo('Bottle Water', daysAgo: 50, quantity: 2),
      Product.byDaysAgo('Nutella', daysAgo: 236),
    ]);
  }

  List<Product> get all => _products;

  List<Product> get expireSoon {
    return _products.sublist(0, min(_products.length, 3));
  }

  void add(Product product) {
    _products.add(product);
    update();
  }

  void remove(Product product) {
    _products.remove(product);
    update();
  }

  void swap(Product product, Product newProduct) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == product.id) {
        _products[i] = newProduct;
        update();
      }
    }
  }

  void update() {
    NotificationScheduler.adjustNotificationCarriedData();
    notifyListeners();
  }
}
