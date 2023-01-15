import 'package:flutter/cupertino.dart';
import 'package:save_my_food/features/notifications/notification_scheduler.dart';
import 'dart:developer';

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

  int get notifyAfterDays {
    return _notifyAfterDays;
  }

  int get notifyAtHour {
    return _notifyAtHour;
  }

  bool get notifyUser {
    return _notifyUser;
  }

  void rescheduleNotifications() {
    NotificationScheduler.cancelAll();
    if (_notifyUser) {
      NotificationScheduler.rescheduleNotification(_notifyAtHour, 0, _notifyAfterDays);
    }
  }

  void changeNotificationDayGap(int days) {
    _notifyAfterDays = days;
    rescheduleNotifications();
  }

  void changeNotificationHour(int hour) {
    _notifyAtHour = hour;
    rescheduleNotifications();
  }

  void switchNotifyUserOption(bool notifyUser) {
    _notifyUser = notifyUser;
    if (!_notifyUser) {
      NotificationScheduler.cancelAll();
    } else {
      rescheduleNotifications();
    }
  }
}
