import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/widgets/medication_entry.dart';

class MedicationListScreen extends StatefulWidget {
  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
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
        return Colors.black; // Default color
    }
  }

  List<Color> backgroundColors = [
    const Color.fromARGB(255, 200, 206, 223),
    const Color.fromARGB(255, 242, 212, 217),
    const Color.fromARGB(255, 211, 199, 216),
    const Color.fromARGB(255, 166, 207, 215),
    const Color.fromARGB(255, 226, 172, 194),
    // Add more colors as needed
  ];

  int colorIndex = 0;

  List<QueryDocumentSnapshot> data = [];

//function to retreive the data from firestore
  getData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("medications")
          .get();

      data.addAll(querySnapshot.docs);
      setState(() {});
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
            // Handle back arrow press
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Medication List',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return MedicationEntry(
                    backgroundColor: const Color.fromARGB(255, 200, 206, 223),
                    medicine: "${data[index]['name']}",
                    dosage: "${data[index]['dosage']}",
                    date: "${data[index]['daysOfWeek']}",
                    time: "${data[index]['preferrefTimes']}",
                    buttonColor: getColorForTime(data[index]['preferrefTimes']),
                    buttonText: '${data[index]['preferrefTimes']}',
                  );
                }),
          ),
        ],
      ),
    );
  }
}

// this code was updated by budur, backgrooudcolor and getColorForTime list to enhance code functionality,
// and to iltrate through each time the user add new medication.