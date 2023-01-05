import 'package:camera/camera.dart';
import 'package:save_my_food/features/food_inventory/product.dart';

class ReceiptScanner {
  static Future<List<Product>> scan(CameraImage receipt) async {
    return [
      Product('Product 1', expiresBy: daysAgo(2)),
      Product('Product 2', expiresBy: daysAgo(3)),
      Product('Product 3', expiresBy: daysAgo(4)),
    ];
  }

  static DateTime daysAgo(int days) {
    return DateTime.now().add(Duration(days: days + 1));
  }
}
