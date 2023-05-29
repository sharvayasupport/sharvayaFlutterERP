import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Meaage Recivied From AppPushNotification : " +
      message.notification.title.toString());
}

class AppPushNotification {
  Future<void> intialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notification Initialized From AppPushNotification");

      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      FirebaseMessaging.onMessage.listen((message) {
        print("Meaage Recivied From AppPushNotification : " +
            message.notification.title.toString());
      });
    }

    await enableIOSNotificationsSetting();
    // await registerLocalNotification();
  }

  Future<void> showNotification(String MessageTitle, String MessageBody) async {
    androidNotificationChannel() => AndroidNotificationChannel(
          Random.secure().nextInt(100000).toString(), // id
          "High Notification Channel", // title
          'This channel is used for important notifications.',
          importance: Importance.max,
        );

    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings =
        const AndroidInitializationSettings('@drawable/sharvaya_logo');
    var iOSSettings = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: (message) async {});

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id, channel.name, channel.description,
        channelShowBadge: true,
        //importance: Importance.min,
        //priority: Priority.low,
        importance: Importance.max,
        priority: Priority.max,
      ),
    );

    flutterLocalNotificationsPlugin.show(
        0, MessageTitle, MessageBody, notificationDetails);
  }

  enableIOSNotificationsSetting() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}
