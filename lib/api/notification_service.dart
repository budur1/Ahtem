import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/screen/notification_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/screen/notification_screen.dart';
// Ensure this path is correct

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initializeNotifications() async {
    await _messaging.requestPermission();

    String? token = await _messaging.getToken();
    print("Firebase Messaging Token: $token");
  }

  // Future<void> initNotifications() async {
  //   _messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //     provisional: false,
  //     carPlay: true,
  //   );
  //   String? token = await _messaging.getToken();
  //   print("Firebase Messaging Token: $token");
  // }

  Future<void> getFCMToken() async {
    String? token = await _messaging.getToken();
    print("Firebase Messaging Token: $token");
  }

  Future<void> MyrequestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      carPlay: true,
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

//   void setupInteractions(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Save the notification when received while the app is in the foreground
//       NotificationStorage.saveNotification(message);
//     });

// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       // Save the notification when a user taps on it and the app is opened
// //       NotificationStorage.saveNotification(message);
// //       print('Message clicked!');
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => NotificationScreen()),
// //       );
// //     });
// //   }
// // }

//     Future<void> backgroundHandler(RemoteMessage message) async {
//       print('Handling a background message ${message.messageId}');
//     }
//   }
// }
}
