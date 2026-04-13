import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Service for handling local push notifications.
///
/// Uses [FlutterLocalNotificationsPlugin] to schedule and cancel notifications.
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Creates a [NotificationService].
  ///
  /// Optionally accepts a [plugin] for testing purposes.
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : flutterLocalNotificationsPlugin =
          plugin ?? FlutterLocalNotificationsPlugin();

  /// Initializes the notification service.
  ///
  /// Sets up timezone settings and platform-specific initialization.
  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestExactAlarmsPermission();
  }

  /// Schedules a notification for a specific time.
  ///
  /// [id] must be a unique integer (usually hashcode of UUID).
  /// [title] and [body] are the notification content.
  /// [time] is the [TimeOfDay] when the notification should trigger.
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(time.hour, time.minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_alarms',
          'Medication Reminders',
          channelDescription: 'Notifications for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels a specific notification by [id].
  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
