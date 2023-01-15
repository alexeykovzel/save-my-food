import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'product.dart';
import 'package:save_my_food/features/notifications/notification_scheduler.dart';

class SavedProducts with ChangeNotifier {
  final List<Product> _products = [];

  SavedProducts() {
    _products.addAll([
      Product.byDaysAgo('Beef', daysAgo: 2, quantity: 999),
      Product.byDaysAgo('Smoke Fi Taco', daysAgo: 3),
      Product.byDaysAgo('Bananas', daysAgo: 4),
      Product.byDaysAgo('Soi soup', daysAgo: 6),
      Product.byDaysAgo('Smetana', daysAgo: 10),
      Product.byDaysAgo('Bottle Water', daysAgo: 50),
      Product.byDaysAgo('Nutella', daysAgo: 236),
    ]);

    NotificationScheduler.init(_products);
  }

  List<Product> get all => _products;

  List<Product> get expireSoon {
    return _products.sublist(0, min(_products.length, 3));
  }

  void add(Product product) {
    _products.add(product);
    notifyListeners();
    NotificationScheduler.adjustNotificationCarriedData();
  }

  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
    NotificationScheduler.adjustNotificationCarriedData();
  }

  void swap(Product product, Product newProduct) {
    for (int i = 0; i < _products.length; i++) {
      if (_products[i].id == product.id) {
        _products[i] = newProduct;
        notifyListeners();
      }
    }
    NotificationScheduler.adjustNotificationCarriedData();
  }
}
