import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../presentation/cubit/get_it.dart';
import '../../presentation/cubit/notification_cubit.dart';
import '../../presentation/view/notification_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static bool _timezoneInitialized = false;

  static void onTap(NotificationResponse details) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<NotificationCubit>(),
          child: const NotificationScreen(),
        ),
      ),
    );
  }

  static Future<void> initNotifications() async {

    InitializationSettings initializationSettings = InitializationSettings(
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
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  static void showNotifications({required int id, required String body}) async {
    NotificationDetails? notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("id1", "base notif"),
    );
    await _plugin.show(id, "Near place", body, notificationDetails);
  }

  static Future<void> scheduleNotifications({
    required int id,
    required String body,
    DateTime? scheduledDate,
  }) async {
    if (!_timezoneInitialized) {
      tz.initializeTimeZones();
      final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
      _timezoneInitialized = true;
    }

    NotificationDetails? notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "id2",
        "schedule notifiction",
        playSound: true,
        channelDescription: "Reminder notifications",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    tz.TZDateTime scheduled;
    if (scheduledDate != null) {
      scheduled = tz.TZDateTime.from(scheduledDate, tz.local);
      if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduled = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
      }
    } else {
      scheduled = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    }

    try {
      await _plugin.zonedSchedule(
        id,
        "Reminder",
        body,
        scheduled,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      // ignore duplicate ID errors silently, log others
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
