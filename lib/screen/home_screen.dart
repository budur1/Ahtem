import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medication_reminder_vscode/services/auth/controllers/user_controller.dart';
import 'package:medication_reminder_vscode/widgets/container_widget.dart';
import 'package:medication_reminder_vscode/widgets/medication_card.dart';
import 'package:medication_reminder_vscode/widgets/tabbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userController = UserController();
  String? _username = 'Mate!';
  int _currentIndex = 0;

  @override
  void initState() {
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
                    onTap: () {},
                    imagePath: "assest/Add_pill_reminder.png",
                    text: "Add pill reminder",
                    color: const Color.fromRGBO(231, 220, 234, 0.75),
                  ),
                  const SizedBox(width: 18), // Space between containers
                  buildContainer(
                    onTap: () {},
                    imagePath: "assest/view_calendar.png",
                    text: "View calendar",
                    color: const Color.fromRGBO(233, 193, 196, 0.75),
                  ),
                  const SizedBox(width: 18), // Space between containers
                  buildContainer(
                    onTap: () {},
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
              child: ListView(
                children: [
                  MedicationContainer(
                    medName: "Atorvastatin",
                    dosage: "2 tablets",
                    date: "Fri, 10 Nov 2023",
                    time: "Afternoon",
                  ),
                  MedicationContainer(
                    medName: "Lisinopril",
                    dosage: "1 tablet",
                    date: "Fri, 10 Nov 2023",
                    time: "Evening",
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/AddMedicationScreen');
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
