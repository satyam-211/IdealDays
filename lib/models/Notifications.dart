import 'package:IdealDays/helpers/SettingsValues.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'task.dart';

class Notifications {
  static FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static void init() {
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    notifications = FlutterLocalNotificationsPlugin();
    notifications.initialize(
      initializationSettings,
      onSelectNotification: (payload) => notificationSelected(payload),
    );
  }

  static Future showNotification(Task t, DateTime date) async {
    var androidDetails = AndroidNotificationDetails(t.id, "Task Notifier",
        "Notifies if you have a task scheduled at a particular time");
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    var now = DateTime.now();
    var scheduledTime =
        DateTime(now.year, now.month, date.day, t.time.hour, t.time.minute)
            .subtract(Duration(minutes: SettingsValues.notifyMeBefore));
    await notifications.schedule(int.parse(t.id), 'Ideal Day Task',
        t.description, scheduledTime, generalNotificationDetails,
        androidAllowWhileIdle: true);
  }

  static Future deleteNotification(String id) async {
    await notifications.cancel(int.parse(id));
  }

  static Future notificationSelected(String payload) async {
    if (payload == null) return;
  }
}
