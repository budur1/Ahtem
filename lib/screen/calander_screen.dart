import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/screen/upcoming_medlist_screen.dart';

class DateandTimePicker extends StatefulWidget {
  @override
  _DateandTimePickerState createState() => _DateandTimePickerState();
}

class _DateandTimePickerState extends State<DateandTimePicker> {
  DateTime _selectedDate = DateTime.now();
  int _selectedIndex = 1; // Index of the "Calendar" icon
  List<ReminderEntry> _reminders = []; // List to hold all reminders

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 53, horizontal: 20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
              )
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                    headline6: TextStyle(fontSize: 20), // Adjust font size here
                  ),
            ),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000, 01, 01),
              lastDate: DateTime(2030, 01, 01),
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                  _updateReminders();
                });
              },
            ),
          ),
          transformAlignment: Alignment.center,
        ),
        SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Your upcoming reminders",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpcomingRemindersScreen(
                      reminders: _reminders,
                    ),
                  ),
                );
              },
              child: Text(
                "See All",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13.54, color: Colors.grey),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: _reminders,
          ),
        )
      ]),
      bottomNavigationBar: CustomTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(index);
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    // Implement navigation logic here if needed
  }

  // Method to filter reminders based on the selected date
  void _updateReminders() {
    // Assuming _reminders is a list of all reminders
    List<ReminderEntry> filteredReminders = _reminders
        .where((reminder) =>
            reminder.date.contains(_selectedDate.toString().substring(0, 10)))
        .toList();

    setState(() {
      _reminders = filteredReminders;
    });
  }
}

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
            Navigator.pushReplacementNamed(context, 'homepage');
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
            Navigator.pushReplacementNamed(context, 'profile');
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
