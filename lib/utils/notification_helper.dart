import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:usap_mobile/main.dart';

class NotificationHelper {
  static Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notification',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDateTime,
  ) async {
    // Convert the provided DateTime to TZDateTime using the local timezone
    TZDateTime scheduledDate = TZDateTime.from(scheduledDateTime, local);

    // Check if the scheduled time is in the past
    TZDateTime now = TZDateTime.now(local);
    if (scheduledDate.isBefore(now)) {
      throw ArgumentError(
        'Scheduled time cannot be in the past. '
        'Scheduled: ${scheduledDate.toString()}, '
        'Current: ${now.toString()}',
      );
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_notification_channel_id',
          'Scheduled Notifications',
          channelDescription:
              'Notification channel for scheduled notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Schedule a weekly repeating notification
  static Future<void> scheduleWeeklyNotification(
    int id,
    String title,
    String body,
    DateTime firstOccurrence,
  ) async {
    TZDateTime scheduledDate = TZDateTime.from(firstOccurrence, local);

    // If the first occurrence is in the past, move it to the next week
    TZDateTime now = TZDateTime.now(local);
    while (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_notification_channel_id',
          'Weekly Notifications',
          channelDescription: 'Notification channel for weekly notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get all pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
