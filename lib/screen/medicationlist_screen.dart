import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/medication_card.dart';
import '../widgets/tabbar.dart';

class MedicationListScreen extends StatefulWidget {
  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> medications = [];

  Color getColorForTime(String time) {
    switch (time) {
      case 'Morning':
        return const Color.fromRGBO(165, 226, 253, 1);
      case 'Afternoon':
        return const Color.fromRGBO(97, 84, 107, 1);
      case 'Night':
        return const Color.fromRGBO(255, 90, 77, 97);
      case 'Evening':
        return const Color.fromRGBO(30, 154, 198, 1);
      default:
        return Colors.black;
    }
  }

  List<Color> backgroundColors = [
    const Color.fromARGB(255, 200, 206, 223),
    const Color.fromARGB(255, 242, 212, 217),
    const Color.fromARGB(255, 211, 199, 216),
    const Color.fromARGB(255, 166, 207, 215),
    const Color.fromARGB(255, 226, 172, 194),
  ];

  int colorIndex = 0;

  // Function to retrieve the data from Firestore
  getData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Medications")
          .get();

      setState(() {
        medications = querySnapshot.docs
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                })
            .toList();
      });
    } catch (error) {
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

  Future<void> deleteMedication(String medicationId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Medications")
          .doc(medicationId)
          .delete();

      // Refresh the list after deletion
      getData();
    } catch (error) {
      print('Error deleting medication: $error');
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey[600],
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homepage');
          },
        ),
        title: const Text('Medication List'),
      ),
      body: medications.isEmpty
          ? Center(child: Text("No medications found."))
          : ListView.builder(
              itemCount: medications.length,
              itemBuilder: (context, index) {
                var medication = medications[index];
                List<bool> daysList = List<bool>.from(medication['daysOfWeek']);
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

                return Dismissible(
                  key: Key(medication['id']),
                  onDismissed: (direction) {
                    deleteMedication(medication['id']);
                    setState(() {
                      medications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${medication['name']} deleted")),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: MedicationContainer(
                    medName: medication['name'],
                    dosage: "${medication['dosage']} Times a Day",
                    date: daysFormatted,
                    time: medication['preferredTimes'],
                    backgroundColor:
                        backgroundColors[index % backgroundColors.length],
                    buttonColor: getColorForTime(medication['preferredTimes']),
                  ),
                );
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
}
