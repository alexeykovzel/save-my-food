import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:save_my_food/features/food_inventory/product.dart';

import 'package:http/http.dart' as http;

bool firstFail = true;
int scanmode = 2;
//1 actual API
//2 LIDL
//3 AH

class ReceiptScanner {
  static Future<List<Product>?> scan(var receipt) async {
    if (firstFail) {
      firstFail = false;
      return null;
    }

    if (scanmode == 1) {
      // Change image type to File and translate it to base 64
      File image = File(receipt.path);
      var bytes = image.readAsBytesSync();
      String img64 = base64Encode(bytes);

      // Send POST request to OCR API
      var response = await http.post(
        Uri.parse('https://api.ocr.space/parse/image'),
        headers: {'apikey': 'K86623584688957'},
        body: {
          "base64Image": "data:image/jpg;base64,$img64",
          'OCREngine': '1',
          'isTable': 'true',
        },
      );

      // Return null if request is not successful
      if (response.statusCode != 200) return null;

      // Get scanned rows from API response
      var json = jsonDecode(response.body);
      String text = json['ParsedResults'][0]['ParsedText'].toUpperCase();
      List<String> rows = const LineSplitter().convert(text);

      // Decode receipt by rows
      return decodeReceipt(rows);
    } else if (scanmode == 2) {
      List<Product> products = [];
      products.add(Product.byDaysAgo("CROISSANT HAM/KAAS",
          daysAgo: Random().nextInt(10)));
      products.add(Product.byDaysAgo("VEG. FOCACCIA PIZZA",
          daysAgo: Random().nextInt(10)));
      products.add(Product.byDaysAgo("SMOOTHIS MANGO-PASSIE",
          daysAgo: Random().nextInt(10)));
      return products;
    } else if (scanmode == 3) {
      List<Product> products = [];
      products.add(
          Product.byDaysAgo("APPLE BANDIT", daysAgo: Random().nextInt(10)));
      products
          .add(Product.byDaysAgo("LAY'S OVEN", daysAgo: Random().nextInt(10)));
      products
          .add(Product.byDaysAgo("HAVERDRANK", daysAgo: Random().nextInt(10)));
      products
          .add(Product.byDaysAgo("OET PIZZA", daysAgo: Random().nextInt(10)));
      return products;
    }
  }

  static List<Product>? decodeReceipt(List<String> rows) {
    if (rows.isEmpty) return null;

    List<String> ah = ["ANTAL", "SUBTOTAAL", "STATIEGELD"];
    List<String> lidl = ["SCHR", "ANTAL", "PET"];

    // Find items to remove and post process rows
    int startOfItems = -1;
    int endOfItems = -1;
    int length = rows.length;
    for (var i = 0; i < length; i++) {
      if ((rows[i].contains(ah[0]) || rows[i].contains(lidl[0])) &&
          startOfItems == -1) {
        startOfItems = i;
      } else if ((rows[i].contains(ah[1]) || rows[i].contains(lidl[1])) &&
          endOfItems == -1) {
        endOfItems = i;
      } else if (rows[i].contains(ah[2]) || rows[i].contains(lidl[2])) {
        rows.removeAt(i);
        length--;
        i--;
        if (endOfItems != -1) {
          endOfItems -= 1;
        }
      }
      if (rows[i][0] == " ") {
        rows[i] = rows[i].substring(1);
      }
      if (double.tryParse(rows[i][0]) != null) {
        rows[i] = rows[i].substring(2);
      }
    }

    if (startOfItems == -1 && endOfItems == -1) {
      return null;
    }

    // Remove information before and after items
    if (endOfItems != -1) rows.removeRange(endOfItems, rows.length);
    if (startOfItems != -1) rows.removeRange(0, startOfItems + 1);

    // Return array with scanned products
    List<Product> products = [];
    for (var i = 0; i < rows.length; i++) {
      int daysAgo = Random().nextInt(10);
      Product product = Product.byDaysAgo(rows[i], daysAgo: daysAgo);
      products.add(product);
    }
    return products;
  }
}
