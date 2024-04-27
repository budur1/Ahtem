import 'package:flutter/material.dart';

class NotificationEntry extends StatelessWidget {
  const NotificationEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      // Text('${message.notification?.title}'),
      subtitle: Text(
        'this is the body',
        //${message.notification?.body}
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
      trailing: Text(
        '12/3/2024',
        //'${message.data}'
        style: TextStyle(fontSize: 10, color: Color.fromRGBO(90, 91, 120, 1)),
      ),
    );
  }
}
