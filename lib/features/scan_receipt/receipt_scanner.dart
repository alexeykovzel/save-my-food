import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:save_my_food/features/food_inventory/product.dart';

import 'package:http/http.dart' as http;

bool _firstFail = true;

class ReceiptScanner {
  static Future<List<Product>?> scan(XFile receipt) async {
    return await _apiScan(receipt);
    // return _testLidlScan();
    // return _testAhScan();
  }

  static List<Product>? _testLidlScan() => _testScan([
        'SMOOTHIS MANGO-PASSIE',
        'VEG. FOCACCIA PIZZA',
        'CROISSANT HAM/KAAS',
      ]);

  static List<Product>? _testAhScan() => _testScan([
        'APPLE BANDIT',
        'LAY\'S OVEN',
        'HAVERDRANK',
        'OET PIZZA',
      ]);

  static List<Product>? _testScan(List<String> productNames) {
    if (!_firstFail) {
      return productNames
          .map((product) => Product.byDaysAgo(_capitalize(product),
              daysAgo: Random().nextInt(10)))
          .toList();
    }
    _firstFail = false;
    return null;
  }

  static Future<List<Product>?> _apiScan(XFile receipt) async {
    // Change image type to File and translate it to base 64
    File image = File(receipt.path);
    var bytes = image.readAsBytesSync();
    String img64 = base64Encode(bytes);

    // Send POST request to OCR API
    var response = await http.post(
      Uri.parse('https://api.ocr.space/parse/image'),
      headers: {'apikey': 'K86623584688957'},
      body: {
        'base64Image': 'data:image/jpg;base64,${img64.toString()}',
        'OCREngine': '2',
        'isTable': 'true',
      },
    );

    // Return null if request is not successful
    if (response.statusCode != 200) return null;

    // Get scanned rows from API response
    var json = jsonDecode(response.body);
    String text = json['ParsedResults'][0]['ParsedText'].toUpperCase();
    List<String> lines = const LineSplitter().convert(text);

    // Decode receipt by rows
    return _findProducts(
      lines,
      ['OMSCHRIJVING', 'ANTAL'],
      ['TOTAAL', 'SUBTOTAAL', 'BETALEN'],
    );
  }

  static List<Product>? _findProducts(
      List<String> lines, List<String> startWords, List<String> endWords) {
    int? startIdx;
    int? endIdx;

    // Find starting and finishing indexes of product lines
    for (int i = 0; i < lines.length; i++) {
      if (startIdx == null && _containsAny(lines[i], startWords)) startIdx = i;
      if (endIdx == null && _containsAny(lines[i], endWords)) endIdx = i;
    }
    // Throw an error if could not find those indexes
    if (startIdx == null || endIdx == null) return null;

    // Convert lines to products with random expiration dates
    List<Product> products = [];
    for (String line in lines.sublist(startIdx + 1, endIdx)) {
      products.add(Product.byDaysAgo(
        _capitalize(line.trim().split('	')[0]),
        daysAgo: Random().nextInt(10),
      ));
    }
    return products;
  }

  static bool _containsAny(String line, List<String> words) {
    return words.where((word) => line.contains(word)).isNotEmpty;
  }

  static String _capitalize(String line) {
    return '${line[0].toUpperCase()}${line.substring(1).toLowerCase()}';
  }

// static List<Product>? _decodeReceipt(List<String> rows) {
//   if (rows.isEmpty) return null;
//
//   List<String> ah = ["ANTAL", "SUBTOTAAL", "STATIEGELD"];
//   List<String> lidl = ["SCHR", "ANTAL", "PET"];
//
//   // Find items to remove and post process rows
//   int startOfItems = -1;
//   int endOfItems = -1;
//   int length = rows.length;
//   for (var i = 0; i < length; i++) {
//     if ((rows[i].contains(ah[0]) || rows[i].contains(lidl[0])) &&
//         startOfItems == -1) {
//       startOfItems = i;
//     } else if ((rows[i].contains(ah[1]) || rows[i].contains(lidl[1])) &&
//         endOfItems == -1) {
//       endOfItems = i;
//     } else if (rows[i].contains(ah[2]) || rows[i].contains(lidl[2])) {
//       rows.removeAt(i);
//       length--;
//       i--;
//       if (endOfItems != -1) {
//         endOfItems -= 1;
//       }
//     }
//     if (rows[i][0] == " ") {
//       rows[i] = rows[i].substring(1);
//     }
//     if (double.tryParse(rows[i][0]) != null) {
//       rows[i] = rows[i].substring(2);
//     }
//   }
//
//   if (startOfItems == -1 && endOfItems == -1) {
//     return null;
//   }
//
//   // Remove information before and after items
//   if (endOfItems != -1) rows.removeRange(endOfItems, rows.length);
//   if (startOfItems != -1) rows.removeRange(0, startOfItems + 1);
//
//   // Return array with scanned products
//   List<Product> products = [];
//   for (var i = 0; i < rows.length; i++) {
//     int daysAgo = Random().nextInt(10);
//     String name = _capitalize(rows[i]);
//     Product product = Product.byDaysAgo(name, daysAgo: daysAgo);
//     products.add(product);
//   }
//   return products;
// }
}
