import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _TabBarState();
}

class _TabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 12,
      unselectedFontSize: 11,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(color: Colors.black),
      fixedColor: const Color.fromRGBO(239, 72, 132, 1),
      backgroundColor: Colors.grey[200],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: widget.currentIndex,
      onTap: (int newIndex) {
        switch (newIndex) {
          case 0:
            Navigator.pushReplacementNamed(context, '/homepage');
            break;

          case 1:
            Navigator.pushReplacementNamed(context, '/calendar');
            break;

          case 2:
            Navigator.pushReplacementNamed(context, '/progress');
            break;

          case 3:
            Navigator.pushReplacementNamed(context, '/NotificationScreen');
            break;

          case 4:
            Navigator.pushReplacementNamed(context, '/profile');
            break;

          default:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Calendar',
          icon: Icon(Icons.calendar_today),
        ),
        BottomNavigationBarItem(
          label: 'Progress',
          icon: Icon(Icons.pivot_table_chart),
        ),
        BottomNavigationBarItem(
          label: 'Notification',
          icon: Icon(Icons.notification_add),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
