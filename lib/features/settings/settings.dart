import 'package:flutter/cupertino.dart';
import 'package:save_my_food/features/notifications/notifications.dart';
import 'dart:developer';

class Settings with ChangeNotifier {
  bool _cardView = true;
  bool deleteExpired = true;
  bool notifyUser = false;
  int _notifyAfterDays = 4;
  int _notifyAtHour = 3;

  bool get cardView => _cardView;

  void toggleView() {
    _cardView = !cardView;
    notifyListeners();
  }

  int getNotifyAfterDays() {
    return _notifyAfterDays;
  }

  int getNotifyAtHour() {
    return _notifyAtHour;
  }

  void rescheduleNotifications() {
    NotificationManager.cancelAll();
    if (_notifyAfterDays != 0 && notifyUser) {
      log("Applying settings");
      NotificationManager.createNotification(scheduledTime: _notifyAtHour, scheduledDayGap: _notifyAfterDays);
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
}
