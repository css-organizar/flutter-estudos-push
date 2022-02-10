import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'application_widget.dart';

Future<void> _messageHandler(RemoteMessage message) async {
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
