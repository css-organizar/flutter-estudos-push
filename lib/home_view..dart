import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_estudos_push_envio/application_config.dart';

class HomeView extends StatefulWidget {
  final String title = 'HomeView';
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
  int messageId = 0;
  String appKey = '';
  TextEditingController titleController = TextEditingController(text: 'Exemplo de Título de Notificação');
  TextEditingController bodyController = TextEditingController(text: 'Exemplo de Corpo da Notificação');

  Future<void> onSelectNotification(String? payload) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hello Everyone'),
        content: Text('$payload'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterNotificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    messaging.getToken().then(
      (value) {
        appKey = value ?? '';
        print(appKey);
      },
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage event) {
        print('message1 - Recebeu em primeiro planos');
        print('title: ${event.notification!.title}');
        print('body: ${event.notification!.body}');
        print('bodyLocArgs: ${event.notification!.bodyLocArgs}');
        print('bodyLocKey: ${event.notification!.bodyLocKey}');
        print('titleLocArgs: ${event.notification!.titleLocArgs}');
        print('titleLocKey: ${event.notification!.titleLocKey}');

        print('channelId: ${event.notification!.android!.channelId.toString()}');
        print('link: ${event.notification!.android!.link.toString()}');
        print('ticker: ${event.notification!.android!.ticker.toString()}');
        print('channelId: ${event.notification!.android!.channelId.toString()}');
        print('channelId: ${event.notification!.android!.channelId.toString()}');
        print('tag: ${event.notification!.android!.tag.toString()}');

        notificationScheduled(
          event.notification!.title!,
          event.notification!.body!,
        );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('Message2 - Recebeu em segundo plano e clicou na notificação!');
        print(message.notification!.body);
      },
    );
  }

  Future notificationDefaultSound() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      importance: Importance.low,
      priority: Priority.low,
      playSound: true,
      color: Colors.amber,
      ledOffMs: 3,
      ledOnMs: 5,
      ledColor: Colors.greenAccent,
      enableLights: true,
      showProgress: true,
      visibility: NotificationVisibility.private,
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    DateTime datahora = DateTime.now();
    var notificationId = '${datahora.hour}${datahora.minute}${datahora.second}';

    flutterNotificationPlugin.show(
      int.parse(notificationId),
      'New Alert',
      'How to show Local Notification',
      platformChannelSpecifics,
      payload: 'Default Sound',
    );
  }

  Future notificationNoSound() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      playSound: false,
      importance: Importance.low,
      priority: Priority.low,
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentSound: false);

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    flutterNotificationPlugin.show(
      0,
      'New Alert',
      'How to show Local Notification',
      platformChannelSpecifics,
      payload: 'No Sound',
    );
  }

  Future<void> notificationCustomSound() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      importance: Importance.low,
      priority: Priority.low,
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(sound: 'slow_spring_board.aiff');

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    flutterNotificationPlugin.show(
      0,
      'New Alert',
      'How to show Local Notification',
      platformChannelSpecifics,
      payload: 'Custom Sound',
    );
  }

  Future<void> notificationScheduled(String title, String body) async {
    tz.initializeTimeZones();

    var time = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));

    messageId++;

    await flutterNotificationPlugin.zonedSchedule(
      messageId,
      title,
      body,
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateTime.now().toIso8601String()),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text('Notification Title'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    label: Text('Notification Body'),
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    http.post(
                      Uri.parse('https://fcm.googleapis.com/fcm/send'),
                      headers: <String, String>{
                        'Authorization': ApplicationConfig.fireMessageKey,
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(
                        <String, dynamic>{
                          'to': appKey,
                          'collapse_key': 'New Message',
                          'priority': 'high',
                          'notification': {
                            'title': titleController.text,
                            'body': bodyController.text,
                          }
                        },
                      ),
                    );
                  },
                  child: const Text('Enviar Notificação via FCM'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    notificationDefaultSound();
                  },
                  child: const Text('Enviar Notificação DefaultSound'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    notificationNoSound();
                  },
                  child: const Text('Enviar Notificação NoSound'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    notificationCustomSound();
                  },
                  child: const Text('Enviar Notificação CustomSound'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    notificationScheduled('Notificação Agendada', 'Claudney');
                  },
                  child: const Text('Enviar Notificação Scheduller'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
