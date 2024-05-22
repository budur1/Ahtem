import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medication_reminder_vscode/services/local_notification.dart';
import '../DataBase/hive.dart';

void scheduleNotificationsFromFirestore() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("No user logged in. Exiting scheduling.");
    return;
  }
  String userId = user.uid;
  FirebaseFirestore.instance
      .collection("Users")
      .doc(userId)
      .collection("Medications")
      .snapshots()
      .listen((snapshot) {
    print("Received snapshot with ${snapshot.docs.length} docs");
    for (var doc in snapshot.docs) {
      var data = doc.data();
      String scheduleType = data['scheduleType'] ?? 'RegularIntervals';
      print(
          "Processing medication: ${data['name']}, Schedule Type: $scheduleType");
      print("Firestore Data: ${doc.data()}");

      DateTime? startDate = safeParseDate(data['startDate']);
      if (startDate == null) {
        print("Invalid start date for ${data['name']}, skipping...");
        continue;
      }

      switch (scheduleType) {
        case 'At Regular Intervals':
          scheduleRegularIntervals(userId, doc.id.hashCode, data, startDate);
          break;
        case 'As Needed':
          scheduleAsNeeded(userId, doc.id.hashCode, data, startDate);
          break;
        case 'On Specific Days of the week':
          scheduleSpecificDaysOfWeek(userId, doc.id.hashCode, data, startDate);
          break;
        default:
          print("Unrecognized schedule type for ${data['name']}");
          break;
      }
    }
  });
}

void scheduleRegularIntervals(
    String userId, int id, Map<String, dynamic> data, DateTime startDate) {
  String name = data['name'];
  int intervalDays = data['intervalDays'] ?? 1;
  List<String> times = getPreferredTimes(data['preferredTimes']);

  for (String timeLabel in times) {
    TimeOfDay timeOfDay = getTimeOfDay(timeLabel);
    DateTime scheduledDate =
        getNextScheduledDateTime(startDate, timeOfDay, intervalDays);
    String uniqueId = generateUniqueNotificationId(userId, name, scheduledDate);
    String title = "Medication Reminder";
    String body = "It's time to take your $name.";

    NotificationService()
        .showNotification(uniqueId.hashCode, title, body, scheduledDate);
    HiveManager().saveNotification(title, body, scheduledDate);
    NotificationService.logScheduledNotifications();
    print("Scheduled Date and Time: ${scheduledDate.toIso8601String()}");
  }
}

void scheduleAsNeeded(
    String userId, int id, Map<String, dynamic> data, DateTime startDate) {
  String name = data['name'];
  List<int> daysOfWeek = parseDaysOfWeek(data);
  List<String> times = getPreferredTimes(data['preferredTimes']);

  for (String timeLabel in times) {
    TimeOfDay timeOfDay = getTimeOfDay(timeLabel);
    DateTime scheduledDate = startDate;

    while (!daysOfWeek.contains(scheduledDate.weekday) ||
        scheduledDate.isBefore(DateTime.now())) {
      scheduledDate = scheduledDate.add(Duration(minutes: 3));
    }

    scheduledDate = DateTime(scheduledDate.year, scheduledDate.month,
        scheduledDate.day, timeOfDay.hour, timeOfDay.minute);
    String uniqueId = generateUniqueNotificationId(userId, name, scheduledDate);
    String title = "Medication Reminder";
    String body = "It's time to take your $name.";

    NotificationService()
        .showNotification(uniqueId.hashCode, title, body, scheduledDate);
    HiveManager().saveNotification(title, body, scheduledDate);
    NotificationService.logScheduledNotifications();
    print("Scheduled Date and Time: ${scheduledDate.toIso8601String()}");
  }
}

// void scheduleSpecificDaysOfWeek(
//     String userId, int id, Map<String, dynamic> data, DateTime startDate) {
//   String name = data['name'];
//   List<int> daysOfWeek = parseDaysOfWeek(data);

//   if (daysOfWeek.isEmpty) {
//     print("No days specified for scheduling for $name.");
//     return;
//   }

//   List<String> times = getPreferredTimes(data['preferredTimes']);
//   for (String timeLabel in times) {
//     TimeOfDay timeOfDay = getTimeOfDay(timeLabel);
//     DateTime scheduledDate = getNextScheduledDateTimeForSpecificDays(
//         startDate, timeOfDay, daysOfWeek);
//     String uniqueId = generateUniqueNotificationId(userId, name, scheduledDate);
//     String title = "Medication Reminder";
//     String body = "It's time to take your $name.";

//     NotificationService()
//         .showNotification(uniqueId.hashCode, title, body, scheduledDate);
//     HiveManager().saveNotification(title, body, scheduledDate);
//     NotificationService.logScheduledNotifications();
//     print("Scheduled Date and Time: ${scheduledDate.toIso8601String()}");
//   }
// }

DateTime getNextScheduledDateTime(
    DateTime startDate, TimeOfDay timeOfDay, int intervalDays) {
  DateTime nextDate = startDate.add(Duration(days: intervalDays));
  while (nextDate.isBefore(DateTime.now())) {
    nextDate = nextDate.add(Duration(days: intervalDays));
  }
  return DateTime(nextDate.year, nextDate.month, nextDate.day, timeOfDay.hour,
      timeOfDay.minute);
}

// DateTime getNextScheduledDateTimeForSpecificDays(
//     DateTime startDate, TimeOfDay timeOfDay, List<int> daysOfWeek) {
//   if (daysOfWeek.isEmpty) {
//     throw Exception('No days of the week provided for scheduling.');
//   }

//   print("Days of the week: $daysOfWeek");

//   DateTime now = DateTime.now();
//   DateTime nextDate = DateTime(startDate.year, startDate.month, startDate.day,
//       timeOfDay.hour, timeOfDay.minute);

//   if (nextDate.isBefore(now)) {
//     nextDate = now.add(Duration(minutes: 1));
//   }

//   int diffDays(int day) => (day - nextDate.weekday + 7) % 7;
//   int minDays = daysOfWeek.map((day) => diffDays(day)).reduce(min);

//   nextDate = nextDate.add(Duration(
//       days: minDays == 0
//           ? 7
//           : minDays)); // Move to the next valid day or the same day next week

//   if (nextDate.isBefore(now)) {
//     throw Exception(
//         "Calculated nextDate is in the past, which shouldn't happen.");
//   }

//   if (nextDate.year > 9999) {
//     throw Exception('DateTime is outside the valid range.');
//   }

//   return nextDate;
// }
void scheduleSpecificDaysOfWeek(
    String userId, int id, Map<String, dynamic> data, DateTime startDate) {
  String name = data['name'];
  List<int> daysOfWeek = parseDaysOfWeek(data);

  if (daysOfWeek.isEmpty) {
    print("No days specified for scheduling for $name.");
    return;
  }

  List<String> times = getPreferredTimes(data['preferredTimes']);
  for (String timeLabel in times) {
    TimeOfDay timeOfDay = getTimeOfDay(timeLabel);
    DateTime now = DateTime.now();

    // Check if today is a valid day and time
    if (daysOfWeek.contains(now.weekday)) {
      DateTime todayScheduledDate = DateTime(
          now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
      if (todayScheduledDate.isAfter(now)) {
        scheduleNotification(userId, name, todayScheduledDate);
        continue; // Move to the next timeLabel as we scheduled for today
      }
    }

    DateTime scheduledDate = getNextScheduledDateTimeForSpecificDays(
        startDate, timeOfDay, daysOfWeek);
    scheduleNotification(userId, name, scheduledDate);
  }
}

void scheduleNotification(String userId, String name, DateTime scheduledDate) {
  String uniqueId = generateUniqueNotificationId(userId, name, scheduledDate);
  String title = "Medication Reminder";
  String body = "It's time to take your $name.";

  NotificationService()
      .showNotification(uniqueId.hashCode, title, body, scheduledDate);
  HiveManager().saveNotification(title, body, scheduledDate);
  NotificationService.logScheduledNotifications();
  print("Scheduled Date and Time: ${scheduledDate.toIso8601String()}");
}

DateTime getNextScheduledDateTimeForSpecificDays(
    DateTime startDate, TimeOfDay timeOfDay, List<int> daysOfWeek) {
  if (daysOfWeek.isEmpty) {
    throw Exception('No days of the week provided for scheduling.');
  }

  print("Days of the week: $daysOfWeek");

  DateTime now = DateTime.now();
  DateTime nextDate =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

  if (nextDate.isBefore(now)) {
    // Move to the next valid day if today has passed the scheduled time
    int diffDays(int day) => (day - now.weekday + 7) % 7;
    int minDays = daysOfWeek.map((day) => diffDays(day)).reduce(min);

    nextDate = nextDate.add(Duration(days: minDays == 0 ? 7 : minDays));
  }

  if (nextDate.year > 9999) {
    throw Exception('DateTime is outside the valid range.');
  }

  return nextDate;
}

TimeOfDay getTimeOfDay(String timeLabel) {
  switch (timeLabel) {
    case 'Morning':
      return TimeOfDay(hour: 9, minute: 0); // for testing
    case 'Afternoon':
      return TimeOfDay(hour: 12, minute: 0);
    case 'Evening':
      return TimeOfDay(hour: 19, minute: 0);
    default:
      return TimeOfDay(hour: 8, minute: 0);
  }
}

DateTime? safeParseDate(String dateString) {
  try {
    List<String> parts = dateString.split('-');
    if (parts.length == 3) {
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
  } catch (e) {
    print("Error parsing date: $e for date string: $dateString");
  }
  return null;
}

List<String> getPreferredTimes(dynamic times) {
  if (times is String) {
    return [times];
  } else if (times is List) {
    return List<String>.from(times);
  } else {
    return [];
  }
}

List<int> parseDaysOfWeek(Map<String, dynamic> data) {
  List<dynamic> daysOfWeek = data['daysOfWeek'];
  List<int> selectedDays = [];

  for (int i = 0; i < daysOfWeek.length; i++) {
    if (daysOfWeek[i] == true) {
      int day = i + 1;
      selectedDays.add(day);
    }
  }

  if (selectedDays.isEmpty) {
    print("No valid days found in the data.");
    throw Exception("No days of the week provided for scheduling.");
  }

  return selectedDays;
}

int generateUniqueId(String userId, String name, DateTime date) {
  return '$userId-$name-${date.toIso8601String()}'.hashCode;
}

void rescheduleNotifications() async {
  var box = Hive.box('notificationBox');
  List notifications = box.values.toList();

  for (var notification in notifications) {
    // Ensure all necessary fields are present and valid
    if (notification['timestamp'] != null &&
        notification['id'] != null &&
        notification['title'] != null &&
        notification['body'] != null) {
      DateTime scheduledDate = DateTime.parse(notification['timestamp']);
      if (scheduledDate.isAfter(DateTime.now())) {
        int id = notification['id'];
        String title = notification['title'];
        String body = notification['body'];

        // Print the original scheduled date before rescheduling
        print(
            "Original scheduled date for notification with ID: $id, Title: $title, Body: $body is: $scheduledDate");

        print(
            "Rescheduling notification with ID: $id, Title: $title, Body: $body, Date: $scheduledDate");
        await NotificationService()
            .showNotification(id, title, body, scheduledDate);
      }
    } else {
      // Log or handle the case where a notification is missing necessary fields
      print("Notification data incomplete or invalid: $notification");
    }
  }
}
