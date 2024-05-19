import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final _userController = UserController();
  String? _username = 'Mate!';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<QueryDocumentSnapshot> data = [];
  Future<void> getData() async {
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
        data = querySnapshot.docs.toList();
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

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Hello, $_username");
              }
              if (snapshot.hasError) {
                return Text("Error");
              }
              if (snapshot.hasData) {
                var userDocument = snapshot.data;
                _username = userDocument?['name'];
                return Text(
                  "Hello, $_username",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                );
              }
              return Text("Hello, $_username");
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "What do you want to do?",
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
                      Navigator.pushReplacementNamed(context, '/calendar');
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
            Row(
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
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/upcoming");
                    },
                    style: TextButton.styleFrom(),
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = data[index];
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

                  return MedicationContainer(
                    medName: doc['name'],
                    dosage: "${doc['dosage']} Times a Day",
                    date: daysFormatted,
                    time: doc['preferredTimes'],
                    backgroundColor:
                        backgroundColors[index % backgroundColors.length],
                    buttonColor: getColorForTime(doc['preferredTimes']),
                  );
                },
              ),
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
