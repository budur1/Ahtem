import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medication_reminder_vscode/services/auth/controllers/user_controller.dart';
import 'package:medication_reminder_vscode/services/permission_handler.dart';
import 'package:medication_reminder_vscode/widgets/container_widget.dart';
import 'package:medication_reminder_vscode/widgets/medication_card.dart';
import 'package:medication_reminder_vscode/widgets/medication_entry.dart';
import 'package:medication_reminder_vscode/widgets/tabbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  List<QueryDocumentSnapshot> data = [];
//function to retreive the data from firestore << for today >>
  getData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime currentDate = DateTime.now();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("medications")
          .where('startDate', isGreaterThanOrEqualTo: currentDate)
          .get();

      List<QueryDocumentSnapshot> filteredMedications = [];

      querySnapshot.docs.forEach((doc) {
        List<String> preferredTimes = List<String>.from(doc["preferredTimes"]);

        // Filter medications to include only those with preferred times that are in the future or match the current time
        if ((preferredTimes.contains("Morning") && currentDate.hour < 12) ||
            (preferredTimes.contains("Afternoon") && currentDate.hour < 17) ||
            (preferredTimes.contains("Evening") && currentDate.hour < 20) ||
            (preferredTimes.contains("Night") && currentDate.hour < 23)) {
          filteredMedications.add(doc);
        }
      });

      setState(() {
        data.addAll(filteredMedications);
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

  final _userController = UserController();
  String? _username = 'Mate!';
  int _currentIndex = 0;

  @override
  void initState() {
    getData();
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final username = await _userController.getUsername();
    setState(() {
      _username = username ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    floatingActionButton:
    NotificationPermissionButton();
    return Scaffold(
        appBar: AppBar(
          // it is temprory just for test
          leading: IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/onboarding1');
            },
          ),
          centerTitle: false,
          title: Text(
            "Hello, $_username", //here we have to get the username
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "what do you want to do?",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 18), // Initial space
                  buildContainer(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/AddNewMed');
                    },
                    imagePath: "assest/Add_pill_reminder.png",
                    text: "Add pill reminder",
                    color: const Color.fromRGBO(231, 220, 234, 0.75),
                  ),
                  const SizedBox(width: 18), // Space between containers
                  buildContainer(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/calander');
                    },
                    imagePath: "assest/view_calendar.png",
                    text: "View calendar",
                    color: const Color.fromRGBO(233, 193, 196, 0.75),
                  ),
                  const SizedBox(width: 18),
                  buildContainer(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/MedList');
                    },
                    imagePath: "assest/Check_medication_list.png",
                    text: "Check medication list",
                    color: const Color.fromRGBO(115, 191, 206, 0.55),
                  ),
                ],
              ),
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    "Pills for Today",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
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
                      buttonColor:
                          getColorForTime(data[index]['preferrefTimes']),
                      buttonText: '${data[index]['preferrefTimes']}',
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/AddNewMed');
          },
          backgroundColor: const Color.fromRGBO(239, 72, 132, 1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
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
