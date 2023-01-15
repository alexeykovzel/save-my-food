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

  static void cancelAll() {
    notification.cancelAll();
  }

  static void adjustNotificationCarriedData() {
    int? daysBeforeNotification = notification.lastConfiguredScheduledDayGap;

    if (daysBeforeNotification == null) {
      return;
    }

    tz.TZDateTime newScheduleDate = tz.TZDateTime.now(tz.local);
    int? offset;
    if (notification.timestamp != null) {
      newScheduleDate = notification.timestamp!;
      offset = tz.TZDateTime.now(tz.local).difference(notification.timestamp!).inDays;
      daysBeforeNotification = daysBeforeNotification - offset;
    }

    String title = "Don't forget about your groceries";
    String data = _calculateExpiredProducts(daysBeforeNotification);

    cancelAll();
    notification.createNotification(title: title, body: data, scheduledDate: newScheduleDate, scheduledDayGap: notification.lastConfiguredScheduledDayGap!, isReschedule: false);
  }

  static void rescheduleNotification(int scheduledHour, int scheduledMinute, int scheduledDayGap) {
    tz.TZDateTime currentTime = tz.TZDateTime.now(tz.local);
    tz.TZDateTime newScheduleDate = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      Time(scheduledHour, scheduledMinute).hour,
      Time(scheduledHour, scheduledMinute).minute,
      Time(scheduledHour, scheduledMinute).second
    );
    String title = "Don't forget about your groceries";
    String data = _calculateExpiredProducts(scheduledDayGap);

    cancelAll();
    notification.createNotification(title: title, body: data, scheduledDate: newScheduleDate, scheduledDayGap: scheduledDayGap, isReschedule: true);
  }

  static String _calculateExpiredProducts(int daysBeforeNotification) {
    if (productList != null) {
      int counter = 0;
      for (int i = 0; i < productList!.length; i++) {
        if (productList![i].daysLeft - daysBeforeNotification <= 2) {
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