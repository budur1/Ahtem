import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationEntry extends StatelessWidget {
  final RemoteMessage? message; // Make the message nullable

  const NotificationEntry({super.key, this.message}); // Remove 'required'

  @override
  Widget build(BuildContext context) {
    // Provide default values if 'message' is null
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: Text(message?.notification?.title ?? 'Default title'),
      subtitle: Text(
        message?.notification?.body ?? 'No new notifications.',
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      trailing: Text(
        message?.sentTime != null
            ? DateFormat('MM/dd/yyyy').format(message!.sentTime!)
            : 'No date',
        style: const TextStyle(
            fontSize: 10, color: Color.fromRGBO(90, 91, 120, 1)),
      ),
    );
  }
}
