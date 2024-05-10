import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/services/local_notification.dart';
import 'package:medication_reminder_vscode/services/permission_handler.dart';

class PermissionHandler {
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    } else {
    
    print('Notification permission denied');
    return false;
  
    }
  }

  Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
}
// notification_permission_button.dart

class NotificationPermissionButton extends StatefulWidget {
  const NotificationPermissionButton({Key? key}) : super(key: key);

  @override
  State<NotificationPermissionButton> createState() =>
      _NotificationPermissionButtonState();
}

class _NotificationPermissionButtonState
    extends State<NotificationPermissionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final permissionHandler = PermissionHandler(); // Create an instance
        final permissionGranted =
            await permissionHandler.requestNotificationPermission();
        if (permissionGranted) {
          final localNotificationService = LocalNotificationService();
          await localNotificationService.init();
          await localNotificationService.showDailySchduledNotification();
        }
      },
      child: Icon(Icons.notifications),
    );
  }
}
