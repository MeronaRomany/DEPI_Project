
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
 static final  FlutterLocalNotificationsPlugin _plugin= FlutterLocalNotificationsPlugin();
 static final GlobalKey<NavigatorState> navigatorKey =
 GlobalKey<NavigatorState>();

 static void onTap(NotificationResponse details) {
   navigatorKey.currentState?.push(
     MaterialPageRoute(
       builder: (_) =>  BlocProvider.value(
         value: getIt<NotificationCubit>(),
         child: NotificationScreen(),
       ),
     ),
   );
 }
 static Future<void> initNotifications() async {
   tz.initializeTimeZones();
   try {
     final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
     tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
   } catch (e) {
     print("Could not get local timezone: $e");
   }
   InitializationSettings initializationSettings =InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:onTap,
        onDidReceiveBackgroundNotificationResponse:onTap,
        );

    // permissions (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

// exact alarm (for scheduled notifications)
  final result= await _plugin
       .resolvePlatformSpecificImplementation<
       AndroidFlutterLocalNotificationsPlugin>()
       ?.requestExactAlarmsPermission();
   print("exact permission $result");

   await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
   await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();
  }

 static void showNotifications({required int id,required String body})async{
   NotificationDetails? notificationDetails=NotificationDetails(
     android: AndroidNotificationDetails("id1","base notif"),
   );
   await _plugin.show(id, "Near place", body, notificationDetails);
 }

 static Future<void> scheduleNotifications({required int id,required String body})async{
   // print(tz.local.name);
   // print("before ${tz.TZDateTime.now(tz.local).hour}");
   //
   // final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
   // tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
   // print(tz.local.name);
   // print("After ${tz.TZDateTime.now(tz.local).hour}");

   NotificationDetails? notificationDetails=NotificationDetails(
     android: AndroidNotificationDetails("id2","schedule notifiction",
         playSound: true,
         channelDescription: "Reminder notifications",
         importance: Importance.max,
         priority: Priority.high),
   );
   print("before schedule");
   final scheduledDate = tz.TZDateTime.now(tz.local).add(
     const Duration(seconds: 10),
   );
   await _plugin.zonedSchedule(
     id,
     "Reminder",
     body,
     scheduledDate,
     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
     notificationDetails,
     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,  );
   print("after schedule");
   final pending =
   await _plugin.pendingNotificationRequests();

   print("pending count ${pending.length}");
 }

 // tz.TZDateTime(
 // tz.local,
 // 2026,
 // 7,
 // 2,
 // 5,
 // 13,
 // )


}