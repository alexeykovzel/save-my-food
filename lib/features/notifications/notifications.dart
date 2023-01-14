import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'dart:developer';

class NotificationManager {
  static final _notificationsAPI = FlutterLocalNotificationsPlugin();
  static int idCounter = 0;

  static Future initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@drawable/background');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _notificationsAPI.initialize(settings);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel 1',
        'productsToExpire',
        importance: Importance.max,
        priority: Priority.max
      ),
    );
  }

  static Future showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    idCounter++;
    _notificationsAPI.show(idCounter, title, body, await _notificationDetails(), payload: payload);
  }

  static Future createNotification({
    String? title,
    String? body,
    String? payload,
    required int scheduledTime,
    required int scheduledDayGap
  }) async {
    idCounter++;

    log(Time(scheduledTime).hour.toString());
    log(Time(scheduledTime).minute.toString());
    log(Time(scheduledTime).second.toString());

    return _notificationsAPI.zonedSchedule(
      idCounter,
      title,
      body,
      _scheduleNotification(Time(scheduledTime), scheduledDayGap),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );
  }

  static tz.TZDateTime _scheduleNotification(Time time, dayGap) {
    final currentTime = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      time.hour,
      time.minute,
      time.second
    );

    return scheduleDate.isBefore(currentTime) ? scheduleDate.add(Duration(days: dayGap)) : scheduleDate;
  }

  static void cancelAll() {
    _notificationsAPI.cancelAll();
    idCounter = 0;
  }
}