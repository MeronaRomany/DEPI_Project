import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    InitializationSettings initializationSettings =InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    _plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:onTap,
        onDidReceiveBackgroundNotificationResponse:onTap,
        );

    // permissions (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

// exact alarm (for scheduled notifications)
   await _plugin
       .resolvePlatformSpecificImplementation<
       AndroidFlutterLocalNotificationsPlugin>()
       ?.requestExactAlarmsPermission();
  }

 static void showNotifications({required int id,required String body})async{
   NotificationDetails? notificationDetails=NotificationDetails(
     android: AndroidNotificationDetails("id1","base notif"),
   );
   await _plugin.show(id, "Near place", body, notificationDetails);
 }

}