import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/routing/routes.dart';
import '../../presentation/cubit/get_it.dart';
import '../../presentation/cubit/notification_cubit.dart';
import '../../presentation/view/notification_screen.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static bool _timezoneInitialized = false;

  static void onTap(NotificationResponse response) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<NotificationCubit>(),
          child: const NotificationScreen(),
        ),
      ),
    );

    // أو يمكنك استخدام:
    // navigatorKey.currentState?.pushNamed(Routes.notif);
  }

  static Future<void> initNotifications() async {
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> showNotifications({
    required int id,
    required String body,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "id1",
        "Base Notifications",
        channelDescription: "General notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id,
      "Near Place",
      body,
      notificationDetails,
    );
  }

  static Future<void> scheduleNotifications({
    required int id,
    required String body,
    DateTime? scheduledDate,
  }) async {
    if (!_timezoneInitialized) {
      tz.initializeTimeZones();

      final timezone = await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(
        tz.getLocation(timezone.identifier),
      );

      _timezoneInitialized = true;
    }

    final NotificationDetails notificationDetails =
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "id2",
        "Scheduled Notifications",
        channelDescription: "Trip Reminder Notifications",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );

    tz.TZDateTime scheduleTime;

    if (scheduledDate != null) {
      scheduleTime = tz.TZDateTime.from(scheduledDate, tz.local);

      if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduleTime =
            tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
      }
    } else {
      scheduleTime =
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    }

    await _plugin.zonedSchedule(
      id,
      "Reminder",
      body,
      scheduleTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}