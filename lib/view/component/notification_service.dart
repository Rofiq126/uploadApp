import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class ServiceNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('launcher');

  void initialNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification({
    required int progress,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max,
            priority: Priority.high,
            icon: 'launcher',
            showProgress: true,
            maxProgress: 100,
            progress: progress);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, 'Melakukan upload', '${progress.toString()}%', notificationDetails,
        payload: 'VIS');
  }
}
