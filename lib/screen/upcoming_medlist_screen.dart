import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/widgets/tabbar.dart';

class UpcomingRemindersScreen extends StatefulWidget {
  const UpcomingRemindersScreen({Key? key}) : super(key: key);

  @override
  _UpcomingRemindersScreenState createState() =>
      _UpcomingRemindersScreenState();
}

class _UpcomingRemindersScreenState extends State<UpcomingRemindersScreen> {
  int _currentIndex = 0;
  List<Color> backgroundColors = [
    const Color.fromARGB(255, 200, 206, 223),
    const Color.fromARGB(255, 242, 212, 217),
    const Color.fromARGB(255, 211, 199, 216),
    const Color.fromARGB(255, 166, 207, 215),
    const Color.fromARGB(255, 226, 172, 194),
  ];

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime currentDate = DateTime.now();
      String formattedDate =
          "${currentDate.year}-${currentDate.month}-${currentDate.day}";

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Medications")
          .where('startDate', isEqualTo: formattedDate)
          .get();

      setState(() {
        data = querySnapshot.docs.map((doc) {
          var docData = doc.data() as Map<String, dynamic>;
          // Ensure 'isTaken' field exists and default to false if not present
          docData['isTaken'] =
              docData.containsKey('isTaken') ? docData['isTaken'] : false;
          return {
            ...docData,
            'id': doc.id,
          };
        }).toList();
      });
    } catch (error) {
      print('Error when getting upcoming data: $error');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'No worries!',
        desc:
            "An error occurred while fetching data. Please check your internet connection and try again later.",
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> _toggleIsTaken(int index, bool isTaken) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String docId = data[index]['id'];

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Medications")
          .doc(docId)
          .update({'isTaken': isTaken});

      setState(() {
        data[index]['isTaken'] = isTaken;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Upcoming Reminders'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var doc = data[index];
                    List<bool> daysList = List<bool>.from(doc['daysOfWeek']);
                    List<String> dayNames = [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat'
                    ];
                    String daysFormatted = daysList
                        .asMap()
                        .entries
                        .where((entry) => entry.value == true)
                        .map((entry) => dayNames[entry.key])
                        .join(", ");
                    return ReminderCard(
                      medicineName: doc['name'],
                      dosage: "${doc['dosage']} Times a Day",
                      reminderDate: daysFormatted,
                      isDone: doc['isTaken'],
                      onToggleDone: (bool val) {
                        _toggleIsTaken(index, val);
                      },
                      backgroundColor:
                          backgroundColors[index % backgroundColors.length],
                    );
                  },
                ),
              )
            ]),
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

class ReminderCard extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String reminderDate;
  final bool isDone;
  final Function(bool) onToggleDone;
  final Color backgroundColor;

  const ReminderCard({
    Key? key,
    required this.medicineName,
    required this.dosage,
    required this.reminderDate,
    this.isDone = false,
    required this.onToggleDone,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicineName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDone ? Colors.black : Colors.black,
              decoration:
                  isDone ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          SizedBox(height: 4),
          Text(
            dosage,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reminderDate,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              GestureDetector(
                onTap: () {
                  onToggleDone(!isDone);
                },
                child: Container(
                  width: 36.8,
                  height: 36.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? Colors.blue : Colors.white,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: isDone
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
