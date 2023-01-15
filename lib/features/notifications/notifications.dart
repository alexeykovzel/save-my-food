import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
        priority: Priority.max
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
    if (_lastNotificationTimestamp == null) {
      _lastNotificationTimestamp = tz.TZDateTime.now(tz.local);
    } else {
      int daysPast = tz.TZDateTime.now(tz.local).difference(_lastNotificationTimestamp!).inDays;
      _lastNotificationTimestamp = daysPast >= scheduledDayGap || isReschedule ? tz.TZDateTime.now(tz.local) : _lastNotificationTimestamp;
    }

    return _notificationsAPI.zonedSchedule(
      _idCounter,
      title,
      body,
      _scheduleNotification(scheduledDate, scheduledDayGap),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );
  }

  tz.TZDateTime _scheduleNotification(tz.TZDateTime scheduleDate, dayGap) {
    final currentTime = tz.TZDateTime.now(tz.local);
    return scheduleDate.isBefore(currentTime) ? scheduleDate.add(Duration(days: dayGap)) : scheduleDate;
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