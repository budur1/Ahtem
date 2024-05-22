import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:medication_reminder_vscode/screen/notification_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal() {
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => NotificationScreen(),
      ));
    }
  }

  Future<void> showNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    try {
      tz.TZDateTime tzScheduledDate =
          tz.TZDateTime.from(scheduledDate, tz.getLocation('Asia/Riyadh'));
      print(
          "Scheduling notification with ID: $id, Title: $title, Body: $body, Scheduled Date: $scheduledDate (TZ: $tzScheduledDate)");
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medication_reminder',
            'Medication Reminder',
            channelDescription: 'Channel for medication reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print("Notification scheduled successfully for $scheduledDate");
    } catch (e) {
      print('Failed to schedule notification: $e');
    }
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> logScheduledNotifications() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var notification in pendingNotificationRequests) {
      print(
          'Pending notification: ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}');
    }
  }

  Future<void> scheduleDailyLifestyleNotification(TimeOfDay time) async {
    String body = getNextLifestyleMessage();
    int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    try {
      var now = DateTime.now();
      var scheduledDate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "Daily Lifestyle Tip",
        body,
        tz.TZDateTime.from(scheduledDate, tz.getLocation('Asia/Riyadh')),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'lifestyle_notification',
            'Lifestyle Notifications',
            channelDescription: 'Channel for daily lifestyle notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      Hive.box('notificationBox').add({
        'id': id,
        'title': "Daily Lifestyle Tip",
        'body': body,
        'timestamp': scheduledDate.toIso8601String(),
      });
      print("Lifestyle notification scheduled for $scheduledDate");
    } catch (e) {
      print('Failed to schedule lifestyle notification: $e');
    }
  }

  String getNextLifestyleMessage() {
    String message = lifestyleMessages[currentMessageIndex];
    currentMessageIndex = (currentMessageIndex + 1) % lifestyleMessages.length;
    return message;
  }
}

List<String> lifestyleMessages = [
  "Time to stretch and take a deep breath!",
  "Drink a glass of water and stay hydrated!",
  "Take a quick walk to clear your mind.",
  "Read a page of a book to relax your mind.",
  "Time to check in with a friend or loved one.",
  "Take a moment to jot down your thoughts.",
  "Do a quick tidy-up of your workspace.",
  "Stretch your legs and take a short walk.",
  "Smile and take a deep breath!",
  "Plan your next meal with healthy options."
];

int currentMessageIndex = 0;

String generateUniqueNotificationId(
    String userId, String medicationName, DateTime date) {
  return '$userId-$medicationName-${date.toIso8601String()}'
      .hashCode
      .toString();
}
