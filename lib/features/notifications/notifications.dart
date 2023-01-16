import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'dart:developer';

class ScheduledNotification {
  final _notificationsAPI = FlutterLocalNotificationsPlugin();
  int _idCounter = 0;
  tz.TZDateTime? _lastNotificationTimestamp;
  int? _lastConfiguredScheduledDayGap;

  Future initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@drawable/background');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _notificationsAPI.initialize(settings);
  }

  Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel 1',
        'productsToExpire',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true
      ),
    );
  }

  Future showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    _idCounter++;
    _notificationsAPI.show(_idCounter, title, body, await _notificationDetails(), payload: payload);
  }

  Future createNotification({
    String? title,
    String? body,
    String? payload,
    required tz.TZDateTime scheduledDate,
    required int scheduledDayGap,
    required bool isReschedule
  }) async {
    _idCounter++;
    _lastConfiguredScheduledDayGap = scheduledDayGap;
    _lastNotificationTimestamp = scheduledDate;

    return _notificationsAPI.zonedSchedule(
      _idCounter,
      title,
      body,
      _scheduleNotification(scheduledDate, scheduledDayGap),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  tz.TZDateTime _scheduleNotification(tz.TZDateTime scheduleDate, dayGap) {
    final currentTime = tz.TZDateTime.now(tz.local);
    String day = "today";

    if (scheduleDate.isBefore(currentTime)) {
      scheduleDate = scheduleDate.add(Duration(days: dayGap));
      day = DateFormat('EEEE').format(scheduleDate);
    }

    showNotification(
        title: "Notification scheduled",
        body: "Reminder set on: $day, ${scheduleDate.hour}:${scheduleDate.minute}"
    );

    // log("scheduled: ${scheduleDate.toString()}");
    // log("current: $currentTime");
    return scheduleDate;
  }

  void cancelAll() {
    _notificationsAPI.cancelAll();
    _idCounter = 0;
  }

  tz.TZDateTime? get timestamp {
    return _lastNotificationTimestamp;
  }

  int? get lastConfiguredScheduledDayGap {
    return _lastConfiguredScheduledDayGap;
  }
}