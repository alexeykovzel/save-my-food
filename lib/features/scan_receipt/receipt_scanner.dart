import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:save_my_food/features/food_inventory/product.dart';

import 'package:http/http.dart' as http;

class ReceiptScanner {
  static Future<List<Product>?> scan(var receipt) async {
    //receive detected and cleaned up text
    return scanAPI(receipt);
  }

  static DateTime daysAgo(int days) {
    return DateTime.now().add(Duration(days: days + 1));
  }

  static Future<List<Product>?> scanAPI(XFile receipt) async {
    //changing image to be of type File and translating it to img64 format image
    File image = File(receipt.path);
    var bytes = image.readAsBytesSync();
    String img64 = base64Encode(bytes);

    //creating body of POST request
    var requestBody = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      'OCREngine': '2',
      'isTable': 'true',
    };

    //sending POST request to OCR API
    var response = await http.post(
        Uri.parse('https://api.ocr.space/parse/image'),
        headers: {'apikey': 'K86623584688957'},
        body: requestBody);
    if (response.statusCode == 200) {
      // checking if the status code is OK, if so: decode JSON
      var responseJson = jsonDecode(response.body);

      //creating a list with all scanned lines
      LineSplitter ls = new LineSplitter();
      List<String> items = ls.convert(
          responseJson['ParsedResults'][0]['ParsedText'].toUpperCase());

      if (items.isNotEmpty) {
        List<String> AH = ["ANTAL", "SUBTOTAAL", "STATIEGELD"];
        List<String> LIDL = ["SCHR", "ANTAL", "PET"];

        //finding items to remove and post processing lines
        int startOfItems = -1;
        int endOfItems = -1;
        int length = items.length;
        for (var i = 0; i < length; i++) {
          if ((items[i].contains(AH[0]) || items[i].contains(LIDL[0])) &&
              startOfItems == -1) {
            startOfItems = i;
          } else if ((items[i].contains(AH[1]) || items[i].contains(LIDL[1])) &&
              endOfItems == -1) {
            endOfItems = i;
          } else if (items[i].contains(AH[2]) || items[i].contains(LIDL[2])) {
            items.removeAt(i);
            length--;
            i--;
            if (endOfItems != -1) {
              endOfItems -= 1;
            }
          }
          if (items[i][0] == " ") {
            items[i] = items[i].substring(1);
          }
          if (double.tryParse(items[i][0]) != null) {
            items[i] = items[i].substring(2);
          }
        }

        if (startOfItems == -1 && endOfItems == -1) {
          return null;
        }

        //removing the information before and after the items
        if (endOfItems != -1) {
          items.removeRange(endOfItems, items.length);
        }
        if (startOfItems != -1) {
          items.removeRange(0, startOfItems + 1);
        }

        //creating a list with all the scanned items
        List<Product> result = [];
        for (var i = 0; i < items.length; i++) {
          result
              .add(Product(items[i], expiresBy: daysAgo(Random().nextInt(10))));
        }

        return result;
      }
    }

    //if no items are found in the scan or if the POST doesn't respond with 200
    return null;
  }
}
