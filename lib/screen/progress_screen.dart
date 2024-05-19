// progress_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:unique_simple_bar_chart/data_models.dart';
import 'package:unique_simple_bar_chart/simple_bar_chart.dart';

import '../services/auth/controllers/user_controller.dart';
import '../widgets/tabbar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<HorizontalDetailsModel> previousStatistics = [];
  List<Map<String, dynamic>> upcomingReminders = [];
  final _userController = UserController();
  String? _username = 'Mate!';
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUpcomingReminders();
  }

  Future<void> _fetchUsername() async {
    final username = await _userController.getUsername();
    setState(() {
      _username = username ?? '';
    });
  }

  Future<void> _fetchUpcomingReminders() async {
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
      upcomingReminders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'isTaken': doc['isTaken'] ?? false
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Color.fromARGB(249, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 21),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Hello $_username',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  }
                  if (snapshot.hasError) {
                    return Text('Error',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  }
                  if (snapshot.hasData) {
                    var userDocument = snapshot.data;
                    _username = userDocument?['name'];
                    return Text('Hello $_username',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  }
                  return Text('Hello $_username',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      width: 343.18,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.49),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 1),
                          Text(
                            'Track your progress over time',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1),
                          Divider(height: 10),
                          SizedBox(height: 1),
                          AspectRatio(
                            aspectRatio: 1.4,
                            child: SfCartesianChart(
                              margin: EdgeInsets.all(9),
                              primaryXAxis: CategoryAxis(
                                labelStyle: TextStyle(fontSize: 10),
                              ),
                              primaryYAxis: NumericAxis(
                                labelPosition: ChartDataLabelPosition.outside,
                                labelStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                                minimum: 0,
                                maximum: 100,
                                interval: 20,
                                labelFormat: '{value}%',
                                title: AxisTitle(
                                  text: 'Percentage of Doses Taken',
                                  textStyle: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              plotAreaBorderWidth: 1,
                              plotAreaBorderColor: Colors.transparent,
                              series: <SplineSeries<SalesData, String>>[
                                SplineSeries<SalesData, String>(
                                  color: Colors.red,
                                  dataSource: _calculateStatistics(),
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SimpleBarChartScreen(
                upcomingReminders: upcomingReminders,
                previousStatistics:
                    previousStatistics, // Pass previous statistics here
              ),
            ),
            SizedBox(height: 3),
            Center(
              child: Container(
                height: 300,
                width: 343.18,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.14),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 1),
                    Text(
                      "Your Adherence Improved by ${_calculateAdherence()}%",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Divider(height: 20),
                    SizedBox(height: 1),
                    CircularPercentIndicator(
                      radius: 120,
                      lineWidth: 20,
                      percent: _calculateAdherence() / 100,
                      center: Text(
                        "${_calculateAdherence()}%",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      progressColor: Color.fromARGB(255, 41, 55, 253),
                      backgroundColor: Color.fromARGB(255, 230, 228, 228),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  List<SalesData> _calculateStatistics() {
    Map<String, int> remindersTakenByMonth = {};

    for (var reminder in upcomingReminders) {
      if (reminder['isTaken']) {
        String month = reminder['name'].split(' ')[0];
        remindersTakenByMonth[month] = (remindersTakenByMonth[month] ?? 0) + 1;
      }
    }

    List<SalesData> statistics = [];
    remindersTakenByMonth.forEach((month, takenCount) {
      int totalCount = upcomingReminders
          .where((reminder) => reminder['name'].startsWith(month))
          .length;
      double percentage = totalCount == 0 ? 0 : (takenCount / totalCount) * 100;
      statistics.add(SalesData(month, percentage));
    });

    return statistics;
  }

  double _calculateAdherence() {
    int totalReminders = upcomingReminders.length;
    if (totalReminders == 0) return 0;

    int takenReminders =
        upcomingReminders.where((reminder) => reminder['isTaken']).length;
    return (takenReminders / totalReminders) * 100;
  }
}

class SimpleBarChartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> upcomingReminders;
  final List<HorizontalDetailsModel> previousStatistics;

  const SimpleBarChartScreen({
    Key? key,
    required this.upcomingReminders,
    required this.previousStatistics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 3),
          Container(
            height: 300,
            width: 343.18,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.49),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Comparison of doses taken and missed",
                      style: TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLegendBox(
                          color: Color.fromARGB(255, 66, 78, 250),
                          text: "Taken",
                        ),
                        SizedBox(height: 2),
                        _buildLegendBox(
                          color: Color.fromARGB(255, 213, 126, 253),
                          text: "Missed",
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1),
                Divider(height: 10),
                SizedBox(height: 1),
                SimpleBarChart(
                  makeItDouble: true,
                  listOfHorizontalBarData: _calculateReminderStatistics(),
                  verticalInterval: 10,
                  horizontalBarPadding: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<HorizontalDetailsModel> _calculateReminderStatistics() {
    List<HorizontalDetailsModel> statistics = List.from(previousStatistics);

    // Your calculation logic here for new statistics

    return statistics;
  }
}

Widget _buildLegendBox({required Color color, required String text}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 4.75,
        backgroundColor: color,
      ),
      SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(fontSize: 9),
      ),
      SizedBox(width: 4),
    ],
  );
}

class SalesData {
  final String year;
  final double sales;

  SalesData(this.year, this.sales);
}

class Reminder {
  final String name;
  final bool isTaken;

  Reminder(this.name, this.isTaken);
}
