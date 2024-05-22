import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/tabbar.dart';
import 'upcoming_medlist_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentIndex = 1;
  List<Map<String, dynamic>> _reminders = [];

  List<Color> backgroundColors = [
    const Color.fromARGB(255, 200, 206, 223),
    const Color.fromARGB(255, 242, 212, 217),
    const Color.fromARGB(255, 211, 199, 216),
    const Color.fromARGB(255, 166, 207, 215),
    const Color.fromARGB(255, 226, 172, 194),
  ];

  @override
  void initState() {
    super.initState();
    _updateReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text('Calendar'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 53, horizontal: 20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                )
              ],
            ),
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000, 1, 1),
              lastDate: DateTime(2030, 1, 1),
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                  _updateReminders();
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Your upcoming reminders",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpcomingRemindersScreen(),
                    ),
                  );
                },
                child: const Text(
                  "See All",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                var reminder = _reminders[index];
                return ReminderCard(
                  medicineName: reminder['name'],
                  dosage: "${reminder['dosage']} Times a Day",
                  reminderDate: formatTimestamp(reminder['startDate']),
                  isDone: reminder['isTaken'],
                  onToggleDone: (bool val) {
                    _toggleIsTaken(index, val);
                  },
                  backgroundColor:
                      backgroundColors[index % backgroundColors.length],
                );
              },
            ),
          ),
        ],
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

  String formatTimestamp(String timestamp) {
    DateTime? dateTime = safeParseDate(timestamp);
    if (dateTime != null) {
      var formatter = DateFormat('dd MMM yyyy');
      return formatter.format(dateTime);
    }
    return timestamp;
  }

  void _updateReminders() async {
    List<Map<String, dynamic>> reminders = await getDataForDate(_selectedDate);
    setState(() {
      _reminders = reminders;
    });
  }

  Future<List<Map<String, dynamic>>> getDataForDate(DateTime date) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String formattedDate = "${date.year}-${date.month}-${date.day}";

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Medications")
          .where('startDate', isEqualTo: formattedDate)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
                'isTaken': doc['isTaken'] ?? false
              })
          .toList();
    } catch (error) {
      print('Error when getting data for date: $error');
      return [];
    }
  }

  void _toggleIsTaken(int index, bool isTaken) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String docId = _reminders[index]['id'];

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Medications")
          .doc(docId)
          .update({'isTaken': isTaken});

      setState(() {
        _reminders[index]['isTaken'] = isTaken;
      });
    } catch (error) {
      print('Error updating isTaken status: $error');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'No worries!',
        desc:
            "An error occurred while updating data. Please check your internet connection and try again later.",
        btnOkOnPress: () {},
      ).show();
    }
  }
}

DateTime? safeParseDate(String dateString) {
  try {
    List<String> parts = dateString.split('-');
    if (parts.length == 3) {
      String year = parts[0];
      String month = parts[1].padLeft(2, '0');
      String day = parts[2].padLeft(2, '0');
      String formattedDate = '$year-$month-$day';
      return DateTime.parse(formattedDate);
    }
  } catch (e) {
    print("Error parsing date: $e for date string: $dateString");
  }
  return null;
}
