import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:save_my_food/features/food_inventory/product.dart';

import 'package:http/http.dart' as http;

class ReceiptScanner {
  static Future<List<Product>?> scan(var receipt) async {
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
        'OCREngine': '2',
        'isTable': 'true',
      },
    );

    // Return null if request is not successful
    if (response.statusCode != 200) return null;

    // Get scanned rows from API response
    var json = jsonDecode(response.body);
    String text = json['ParsedResults'][0]['ParsedText'].toUpperCase();
    List<String> rows = const LineSplitter().convert(text);

    // Return null if no rows, otherwise decode receipt
    return rows.isEmpty ? null : decodeReceipt(rows);
  }

  static List<Product>? decodeReceipt(List<String> rows) {
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
    List<Product> result = [];
    for (var i = 0; i < rows.length; i++) {
      int daysAgo = Random().nextInt(10);
      Product product = Product.byDaysAgo(rows[i], days: daysAgo);
      result.add(product);
    }
    return result;
  }
}
