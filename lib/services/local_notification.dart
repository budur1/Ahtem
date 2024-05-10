import 'dart:math';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// 1. setup
class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const String channelId = 'lifestyle_channel_id';

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      InitializationSettings settings = InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ));
      await flutterLocalNotificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {},
        onDidReceiveBackgroundNotificationResponse: (details) {},
      );
    } catch (e) {
      print('Error initializing local notifications: $e');
    }
  }

//showDailySchduledNotification
  Future showDailySchduledNotification() async {
    print('Scheduling daily notification...');
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      channelId,
      'Daily Scheduled Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    // Randomly select a lifestlye tip
    Random random = Random();
    int index = random.nextInt(lifestyleTips.length);
    String randomTip = lifestyleTips[index];

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
    var currentTime = tz.TZDateTime.now(tz.local);
    print("currentTime.year:${currentTime.year}");
    print("currentTime.month:${currentTime.month}");
    print("currentTime.day:${currentTime.day}");
    print("currentTime.hour:${currentTime.hour}");
    print("currentTime.minute:${currentTime.minute}");
    print("currentTime.second:${currentTime.second}");
    // var scheduleTime = tz.TZDateTime(
    //   tz.local,
    //   currentTime.year,
    //   currentTime.month,
    //   currentTime.day,
    //   4,
    //   18,
    // );
    var scheduleTime = tz.TZDateTime.now(tz.local).add(
      const Duration(seconds: 10), // Set notification time to 9 AM
    );
    if (scheduleTime.isBefore(currentTime)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Lifestyle Tip',
      randomTip,
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      scheduleTime,
      details,
      payload: 'Daily Lifestyle Tip',

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> onSelectNotification(String? payload) async {
    // Handle notification selection
    print('Notification selected: $payload');
  }

  final List<String> lifestyleTips = [
    'Drink plenty of water to stay hydrated throughout the day.',
    'Take short breaks and stretch if you sit for long periods.',
    'Include fruits and vegetables in your diet for a balanced nutrition.',
    'Exercise regularly to maintain a healthy body and mind.',
    'Get enough sleep each night to feel rested and rejuvenated.'
  ];
// static Future<void> scheduleNotification(
//     String medicationName, DateTime reminderTime) async {
//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     channelId,
//     'Medication Reminders',
//    // 'Reminders for medication times',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//      android: androidPlatformChannelSpecifics, iOS: null);
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     medicationName.hashCode,
//     'Medication Reminder',
//     'Time to take $medicationName',
//     tz.TZDateTime.from(reminderTime, tz.local),
//    platformChannelSpecifics,
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//   );
// }
}
