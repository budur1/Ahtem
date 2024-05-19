import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../widgets/tabbar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentIndex = 3;
  List<int> tappedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox('notificationBox'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.error != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Notifications"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () async {
                      await clearAllNotifications();
                    },
                  ),
                ],
              ),
              body: Center(
                child: Text(
                    "Failed to open notification history. Please restart the app."),
              ),
            );
          } else {
            final box = snapshot.data!;
            final notifications = box.values.toList();

            return Scaffold(
              appBar: AppBar(
                title: Text("Notifications"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () async {
                      await clearAllNotifications();
                    },
                  ),
                ],
              ),
              body: notifications.isEmpty
                  ? Center(child: Text("No notifications found."))
                  : RefreshIndicator(
                      child: Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            var notification = notifications[index];
                            bool isLifestyle =
                                notification['title'].contains("Lifestyle");
                            return Dismissible(
                              key: Key(notification.hashCode.toString()),
                              onDismissed: (direction) {
                                box.deleteAt(index);
                                setState(() => notifications.removeAt(index));
                              },
                              background: Container(color: Colors.red),
                              child: Card(
                                elevation: 5,
                                child: ListTile(
                                  leading: Icon(
                                    isLifestyle
                                        ? Icons.favorite
                                        : Icons.medication,
                                    color: isLifestyle
                                        ? Color.fromRGBO(239, 72, 132, .8)
                                        : const Color.fromRGBO(30, 145, 198, 1),
                                  ),
                                  title: Text(notification['title']),
                                  subtitle: Text(notification['body']),
                                  trailing: Text(formatTimestamp(
                                      notification['timestamp'])),
                                  tileColor: tappedIndexes.contains(index)
                                      ? Colors.grey[300]
                                      : Colors.white,
                                  onTap: () {
                                    setState(() {
                                      if (tappedIndexes.contains(index)) {
                                        tappedIndexes.remove(index);
                                      } else {
                                        tappedIndexes.add(index);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      onRefresh: () async {
                        await box
                            .compact(); // compact the box to clean up deleted entries
                        setState(() {});
                      },
                    ),
              bottomNavigationBar: CustomTabBar(
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading..."),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  String formatTimestamp(String timestamp) {
    var dateTime = DateTime.parse(timestamp);
    var formatter = DateFormat('dd MMM yyyy hh:mm a');
    return formatter.format(dateTime);
  }

  Future<void> clearAllNotifications() async {
    var box = Hive.box('notificationBox');
    await box.clear();
    setState(() {});
  }
}
