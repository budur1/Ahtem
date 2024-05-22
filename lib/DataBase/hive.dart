import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static final HiveManager _singleton = HiveManager._internal();

  factory HiveManager() {
    return _singleton;
  }

  HiveManager._internal();

  /// Initialize Hive and open all necessary boxes
  Future<void> initHive() async {
    await Hive.initFlutter();
    await openBoxes();
  }

  /// Open all boxes used in the application
  Future<void> openBoxes() async {
    await Hive.openBox('notificationBox');
  }

  /// Get an open box or open it if it's not yet opened
  Future<Box> getBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  /// Save notification data to Hive
  Future<void> saveNotification(
      String title, String body, DateTime scheduledDate) async {
    int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    Hive.box('notificationBox').add({
      'id': id,
      'title': title,
      'body': body,
      'timestamp': scheduledDate.toIso8601String(),
    });
    print(
        "Notification saved with ID: $id, Title: $title, Body: $body, Date: $scheduledDate");
  }

  /// Close all open boxes - can be called when app is terminating
  void closeAllBoxes() {
    Hive.close();
  }
}
