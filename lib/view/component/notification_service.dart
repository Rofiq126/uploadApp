import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ServiceNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('launcher');

  void initialNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void progressNotification(
      {required int progress, required String condition}) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max,
            priority: Priority.max,
            icon: 'launcher',
            showProgress: true,
            autoCancel: false,
            maxProgress: 100,
            progress: progress);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()!
    //     .requestNotificationsPermission();

    await flutterLocalNotificationsPlugin.show(
        0, condition, '${progress.toString()}%', notificationDetails,
        payload: 'VIS');
  }

  void alertNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.max,
      icon: 'launcher',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(0, 'Upload Canceled ', '', notificationDetails, payload: 'VIS');
  }
}
