import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/widgets/container_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/onboarding1');
          },
        ),
        centerTitle: false,
        title: const Text(
          "Hello, ",
          textAlign: TextAlign.left,
          style: TextStyle(
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
                  imagePath: "assest/Add_pill_reminder.png",
                  text: "Add pill reminder",
                  color: const Color.fromRGBO(231, 220, 234, 0.75),
                ),
                const SizedBox(width: 18), // Space between containers
                buildContainer(
                  imagePath: "assest/view_calendar.png",
                  text: "View calendar",
                  color: const Color.fromRGBO(233, 193, 196, 0.75),
                ),
                const SizedBox(width: 18), // Space between containers
                buildContainer(
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
          const Card(
            child: Text("data"),
          )
        ],
      ),
    );
  }
}
