import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'application_widget.dart';

void startNotificationInBackground() {
  FlutterLocalNotificationsPlugin flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'Notification Channel ID',
    'Channel Name',
    playSound: false,
    importance: Importance.max,
    priority: Priority.high,
  );

  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentSound: false);

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  flutterNotificationPlugin.show(
    0,
    'New Alert',
    'How to show Local Notification',
    platformChannelSpecifics,
    payload: 'No Sound',
  );
}

Future<void> _messageHandler(RemoteMessage message) async {
  startNotificationInBackground();

  print('Message3 - Recebeu em segundo plano direto!');
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    const ApplicationWidget(),
  );
}

init() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  debugPrint = (String? message, {int? wrapWidth}) {};
}
