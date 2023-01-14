import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'product.dart';

class SavedProducts with ChangeNotifier {
  final List<Product> _products = [];

  String meatImage =
      'https://www.freepnglogos.com/uploads/meat-png/meat-png-image-purepng-transparent-png-image-14.png';
  String fruitsImage =
      'https://www.freepnglogos.com/uploads/fruits-png/fruits-png-image-fruits-png-image-download-39.png';
  String soupImage =
      'https://www.freepnglogos.com/uploads/soup-png/soup-feast-big-chef-slot-royal-vegas-online-casino-0.png';
  String bottleImage =
      'https://www.freepnglogos.com/uploads/water-bottle-png/water-bottle-bottle-water-maza-turkish-mediterranean-las-vegas-12.png';
  String sweetImage =
      'https://www.freepnglogos.com/uploads/chocolate-png/chocolate-william-dean-chocolates-edible-creations-rtx-traveler-14.png';

  SavedProducts() {
    _products.addAll([
      Product('Beef', expiresBy: daysAgo(2), quantity: 999, image: meatImage),
      Product('Smoke Fi Taco', expiresBy: daysAgo(3)),
      Product('Bananas', expiresBy: daysAgo(4), image: fruitsImage),
      Product('Soi soup', expiresBy: daysAgo(6), image: soupImage),
      Product('Smetana', expiresBy: daysAgo(10)),
      Product('Bottle Water', expiresBy: daysAgo(50), image: bottleImage),
      Product('Nutella', expiresBy: daysAgo(236), image: sweetImage),
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

  void edit(Product product, Product newProduct) {
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
