import 'package:flutter/cupertino.dart';

class Settings with ChangeNotifier {
  bool _deleteExpired = true;
  bool _notifyUser = false;
  int _notifyAfterDays = 4;
  int _notifyAtHour = 3;

  bool get deleteExpired => _deleteExpired;

  set deleteExpired(bool isOn) {
    _deleteExpired = isOn;
    notifyListeners();
  }

  bool get notifyUser => _notifyUser;

  set notifyUser(bool isOn) {
    _notifyUser = isOn;
    notifyListeners();
  }

  int get notifyAfterDays => _notifyAfterDays;

  set notifyAfterDays(int days) {
    _notifyAfterDays = days;
    notifyListeners();
  }

  int get notifyAtHour => _notifyAtHour;

  set notifyAtHour(int hour) {
    _notifyAtHour = hour;
    notifyListeners();
  }
}
