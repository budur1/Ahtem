import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medication_reminder_vscode/widgets/notification_entry.dart';
import 'package:medication_reminder_vscode/widgets/tabbar.dart';

class NotificationScreen extends StatefulWidget {
  final RemoteMessage? message;
  const NotificationScreen({Key? key, this.message}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification',
              style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              NotificationEntry(message: widget.message),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: CustomTabBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
