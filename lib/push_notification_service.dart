import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_list/external_lead_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request/leave_request_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';

// ignore: slash_for_doc_comments
/**
 * Documents added by Alaa, enjoy ^-^:
 * There are 3 major things to consider when dealing with push notification :
 * - Creating the notification
 * - Hanldle notification click
 * - App status (foreground/background and killed(Terminated))
 *
 * Creating the notification:
 *
 * - When the app is killed or in background state, creating the notification is handled through the back-end services.
 *   When the app is in the foreground, we have full control of the notification. so in this case we build the notification from scratch.
 *
 * Handle notification click:
 *
 * - When the app is killed, there is a function called getInitialMessage which
 *   returns the remoteMessage in case we receive a notification otherwise returns null.
 *   It can be called at any point of the application (Preferred to be after defining GetMaterialApp so that we can go to any screen without getting any errors)
 * - When the app is in the background, there is a function called onMessageOpenedApp which is called when user clicks on the notification.
 *   It returns the remoteMessage.
 * - When the app is in the foreground, there is a function flutterLocalNotificationsPlugin, is passes a future function called onSelectNotification which
 *   is called when user clicks on the notification.
 *
 * */

class PushNotificationService {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
    //await getInstance.allReady();
    getToken();
// Get any messages which caused the application to open from a terminated state.
    // If you want to handle a notification click when the app is terminated, you can use `getInitialMessage`
    // to get the initial message, and depending in the remoteMessage, you can decide to handle the click
    // This function can be called from anywhere in your app, there is an example in main file.
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    // // If the message also contains a data property with a "type" of "chat",
    // // navigate to a chat screen
    // if (initialMessage != null) {
    //   // Navigator.pushNamed(context, '/chat',
    //   //     arguments: ChatArguments(initialMessage));
    //   debugPrint("initial message received");
    //   handleNotification(
    //       messageData: initialMessage.data, needToStartApp: true);
    // }
// Also handle any interaction when the app is in the background via a
    // Stream listener
    // This function is called when the app is in the background and user clicks on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      // if (message.data['type'] == 'chat') {
      //   // Navigator.pushNamed(context, '/chat',
      //   //     arguments: ChatArguments(message));
      // }

      print("messageData1232" + message.notification.toString());
    });
    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      debugPrint("device token: ${token}");
    }
  }

  getTokenAsString() async {
    var token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      return token.toString();
    } else {
      token = "";
    }
  }

  registerNotificationListeners() async {
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
        onSelectNotification: (message) async {
      // This function handles the click in the notification when the app is in foreground
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      Map<String, dynamic> dataMap =
          message != null ? jsonDecode(message) : null;
      if (dataMap != null) {
        {
          print("DataMap" + dataMap.toString());
          print("On Forgorund Notification" +
              " Body : " +
              dataMap['body'] +
              " Title : " +
              dataMap['title']);

          if (dataMap['title'] == "Inquiry") {
            navigateTo(Globals.context, InquiryListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "FollowUp") {
            List<String> SplitSTr = dataMap['body'].split("By");
            print("NotificationSplitedValue" +
                " Value : " +
                SplitSTr[0].toString() +
                " 2nd : " +
                SplitSTr[1].toString());
            //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);

            navigateTo(Globals.context, FollowupListScreen.routeName,
                    clearAllStack: true,
                    arguments:
                        FollowupListScreenArguments(SplitSTr[1].toString()))
                .then((value) {
              SplitSTr = [];
            });
            //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
          } else if (dataMap['title'] == "Quotation") {
            navigateTo(Globals.context, QuotationListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "Sales Order") {
            navigateTo(Globals.context, SalesOrderListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "Sales Invoice") {
            navigateTo(Globals.context, SalesBillListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "Complaint") {
            navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "To-Do") {
            navigateTo(Globals.context, ToDoListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "Leave Request") {
            navigateTo(Globals.context, LeaveRequestListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "TeleCaller") {
            navigateTo(Globals.context, TeleCallerListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "Quick Inquiry") {
            navigateTo(Globals.context, InquiryListScreen.routeName,
                clearAllStack: true);
          } else if (dataMap['title'] == "Portal Lead") {
            navigateTo(Globals.context, ExternalLeadListScreen.routeName,
                clearAllStack: true);
          }
        }
      }
    });
// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Get.find<HomeController>().getNotificationsNumber();
      print("Remotttt" + message.data['body']);
      String data;

      if (message != null) {
        data = jsonEncode(message.data);
      }

      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
// If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  channelShowBadge: true,
                  importance: Importance.min,
                  priority: Priority.low,
                  timeoutAfter: 100000,
                  styleInformation: DefaultStyleInformation(true, true),
                  playSound: true,
                  ongoing: true,
                  visibility: NotificationVisibility.public),
            ),
            payload: data);
      }
      //  message = null;
    });
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.',
        importance: Importance.defaultImportance,
      );

  // handle notification data

  // start chat screen
}
