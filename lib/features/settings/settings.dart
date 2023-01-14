import 'package:flutter/cupertino.dart';

class Settings with ChangeNotifier {
  bool _cardView = true;
  bool deleteExpired = true;
  bool notifyUser = false;
  int notifyAfterDays = 4;
  int notifyAtHour = 3;

  bool get cardView => _cardView;

  void toggleView() {
    _cardView = !cardView;
    notifyListeners();
  }
}
