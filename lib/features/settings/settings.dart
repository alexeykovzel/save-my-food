import 'package:flutter/cupertino.dart';

class Settings with ChangeNotifier {
  bool _cardView = true;
  bool deleteExpired = true;
  bool notifyUser = false;
  int notifyAfterDays = 4;
  int _notifyAtMinute = 10;
  int _notifyAtHour = 3;

  int get notifyAtMinute => _notifyAtMinute;

  set notifyAtMinute(int minute) {
    _notifyAtMinute = minute;
    notifyListeners();
  }

  int get notifyAtHour => _notifyAtHour;

  set notifyAtHour(int hour) {
    _notifyAtHour = hour;
    notifyListeners();
  }

  String get notifyAt =>
      '${(_notifyAtHour < 10 ? '0' : '') + _notifyAtHour.toString()}:'
      '${(_notifyAtMinute < 10 ? '0' : '') + _notifyAtMinute.toString()}';

  bool get cardView => _cardView;

  void toggleView() {
    _cardView = !cardView;
    notifyListeners();
  }
}
