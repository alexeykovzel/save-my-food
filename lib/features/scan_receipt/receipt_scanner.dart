import 'dart:math';

import 'package:camera/camera.dart';
import 'package:save_my_food/features/food_inventory/product.dart';

class ReceiptScanner {
  static Future<List<Product>?> scan(XFile receipt) async {
    bool success = Random().nextDouble() < 0.8;
    return success
        ? [
            Product('Product 1', expiresBy: daysAgo(2)),
            Product('Product 2', expiresBy: daysAgo(3)),
            Product('Product 3', expiresBy: daysAgo(4)),
          ]
        : null;
  }

  static DateTime daysAgo(int days) {
    return DateTime.now().add(Duration(days: days + 1));
  }
}
