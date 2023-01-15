import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:save_my_food/features/food_inventory/product.dart';
import 'package:save_my_food/features/notifications/notifications.dart';

class NotificationScheduler {
  static List<Product>? productList;
  static ScheduledNotification notification = ScheduledNotification();

  static void init(List<Product> products) async {
    productList = products;
    await notification.initialize();
  }

  static void test() {
    notification.showNotification(title: "TEST", body: "Test notification");
  }

  static void cancelAll() {
    notification.cancelAll();
  }

  static void adjustNotificationCarriedData() {
    int? daysBeforeNotification = notification.lastConfiguredScheduledDayGap;
    tz.TZDateTime? newScheduleDate = notification.timestamp;

    if (newScheduleDate == null || daysBeforeNotification == null) {
      return;
    }

    String title = "Don't forget about your groceries";
    String data = _calculateExpiredProducts();

    cancelAll();
    notification.createNotification(
      title: title,
      body: data,
      scheduledDate: newScheduleDate,
      scheduledDayGap: daysBeforeNotification,
      isReschedule: false);
  }

  static void rescheduleNotification(int scheduledHour, int scheduledMinute, int scheduledDayGap) {
    tz.TZDateTime currentTime = tz.TZDateTime.now(tz.local);
    Time newTime = Time(scheduledHour, scheduledMinute, 0);

    tz.TZDateTime newScheduleDate = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      newTime.hour - 1,
      newTime.minute,
      newTime.second
    );
    String title = "Don't forget about your groceries";
    String data = _calculateExpiredProducts();

    cancelAll();
    notification.createNotification(title: title, body: data, scheduledDate: newScheduleDate, scheduledDayGap: scheduledDayGap, isReschedule: true);
  }

  static String _calculateExpiredProducts() {
    if (productList != null) {
      int counter = 0;
      for (int i = 0; i < productList!.length; i++) {
        if (productList![i].daysLeft <= 2) {
          counter++;
        }
      }
      if (counter > 0) {
        return "$counter items in your inventory will expire in 2 days";
      }
    }
    return '';
  }
}