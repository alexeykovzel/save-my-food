import 'package:flutter/cupertino.dart';
import 'package:save_my_food/features/notifications/notification_scheduler.dart';
import 'dart:developer';

class Settings with ChangeNotifier {
  bool _cardView = true;
  bool deleteExpired = true;
  bool _notifyUser = false;
  int _notifyAfterDays = 4;
  int _notifyAtMinute = 10;
  int _notifyAtHour = 3;

  int get notifyAtMinute => _notifyAtMinute;

  set notifyAtMinute(int minute) {
    _notifyAtMinute = minute;
    notifyListeners();
    rescheduleNotifications();
  }

  int get notifyAtHour => _notifyAtHour;

  set notifyAtHour(int hour) {
    _notifyAtHour = hour;
    notifyListeners();
    rescheduleNotifications();
  }

  String get notifyAt =>
      '${(_notifyAtHour < 10 ? '0' : '') + _notifyAtHour.toString()}:'
      '${(_notifyAtMinute < 10 ? '0' : '') + _notifyAtMinute.toString()}';

  bool get cardView => _cardView;

  void toggleView() {
    _cardView = !cardView;
    notifyListeners();
  }

  int get notifyAfterDays {
    return _notifyAfterDays;
  }

  set notifyAfterDays(int days) {
    _notifyAfterDays = days;
    rescheduleNotifications();
  }

  bool get notifyUser {
    return _notifyUser;
  }

  set notifyUser (bool isOn) {
    _notifyUser = isOn;
    if (!_notifyUser) {
      NotificationScheduler.cancelAll();
    } else {
      rescheduleNotifications();
    }
  }

  void rescheduleNotifications() {
    NotificationScheduler.cancelAll();
    if (_notifyUser) {
      NotificationScheduler.rescheduleNotification(_notifyAtHour, _notifyAtMinute, _notifyAfterDays);
    }
  }
}
