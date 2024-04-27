// this file will contains all the notification logic
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medication_reminder_vscode/main.dart';

class FirebaseApi {
// 1. create an instance of the Firebase Messsagaing
  final _firebaseMessaaging = FirebaseMessaging.instance;

// 2. function to initialize notification
  Future<void> initNotifications() async {
    // 2.1. permission method (from user)
    await _firebaseMessaaging.requestPermission();

    // 2.2 fetch thr FCM token for this device
    final FCMToken = await _firebaseMessaaging.getAPNSToken();

    // 2.3 print the token (normally you would send this to your server)
    print(
        "------------------------------------------------------------Token:${FCMToken}");

    // calling the method
    initPushNotification();
  }

// 4. function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // if null return nothing
    if (message == null) return;

    //navigate to Notification Screen
    navigateKey.currentState?.pushNamed(
      "/Notification_screen",
      arguments: message,
    );
  }

// 5. function to initialize background settings
  Future initPushNotification() async {
    // handle the notifications if the app was terminated and now opend
    FirebaseMessaging.instance.getInitialMessage().then((handleMessage));

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen((handleMessage));
  }
}
