import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/screen/notification_screen.dart';

class NotificationService {
  Future<void> getFCMToken() async {
    String? token = await _messaging.getToken();
    print("Firebase Messaging Token: $token");
  }

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
// Request permission
  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission.');
    } else {
      print('User declined or has not accepted permission.');
    }
  }

  Future<void> subscribeToTopic() async {
    await _messaging.subscribeToTopic('lifestyleTips');
    print('Subscribed to lifestyleTips topic');
  }

  void setupInteractions(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(message: message),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the user taps on a notification when the app is in the background
      print('Message clicked!');
    });
  }
}
