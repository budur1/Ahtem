import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Medications")
        .get();

    setState(() {
      upcomingReminders = querySnapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'isTaken': doc['isTaken'] ?? false,
                'id': doc.id,
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(249, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 21),
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  }
                  if (snapshot.hasError) {
                    return const Text('Error',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  }
                  if (snapshot.hasData) {
                    var userDocument = snapshot.data;
                    _username = userDocument?['name'];
                    return Text('Hello $_username',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  }
                  return Text('Hello $_username',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold));
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.49),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 1),
                          const Text(
                            'Track your progress over time',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          const Divider(height: 10),
                          const SizedBox(height: 1),
                          AspectRatio(
                            aspectRatio: 1.4,
                            child: SfCartesianChart(
                              margin: const EdgeInsets.all(9),
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(fontSize: 10),
                              ),
                              primaryYAxis: NumericAxis(
                                labelPosition: ChartDataLabelPosition.outside,
                                labelStyle: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                                minimum: 0,
                                maximum: 100,
                                interval: 20,
                                labelFormat: '{value}%',
                                title: const AxisTitle(
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
                                      const DataLabelSettings(isVisible: true),
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SimpleBarChartScreen(
                upcomingReminders: upcomingReminders,
                previousStatistics: previousStatistics,
              ),
            ),
            const SizedBox(height: 3),
            Center(
              child: Container(
                height: 300,
                width: 343.18,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.14),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 1),
                    Text(
                      "Your Adherence Improved by ${_calculateAdherence().toInt()}%",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20),
                    const SizedBox(height: 1),
                    CircularPercentIndicator(
                      radius: 120,
                      lineWidth: 20,
                      percent: _calculateAdherence() / 100,
                      center: Text(
                        "${_calculateAdherence().toInt()}%",
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      progressColor: const Color.fromARGB(255, 41, 55, 253),
                      backgroundColor: const Color.fromARGB(255, 230, 228, 228),
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
      DateTime? date = safeParseDate(reminder['startDate']);
      if (date != null) {
        String month = DateFormat('MMM yyyy').format(date);

        if (reminder['isTaken']) {
          remindersTakenByMonth[month] =
              (remindersTakenByMonth[month] ?? 0) + 1;
        }
      }
    }

    List<SalesData> statistics = [];
    remindersTakenByMonth.forEach((month, takenCount) {
      int totalCount = upcomingReminders.where((reminder) {
        DateTime? date = safeParseDate(reminder['startDate']);
        return date != null && DateFormat('MMM yyyy').format(date) == month;
      }).length;
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
    return (takenReminders / totalReminders) * 100.toInt();
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
          const SizedBox(height: 3),
          Container(
            height: 300,
            width: 343.18,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.49),
              color: Colors.white,
              boxShadow: const [
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
                    const Text(
                      "Comparison of doses taken and missed",
                      style: TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLegendBox(
                          color: const Color.fromARGB(255, 66, 78, 250),
                          text: "Taken",
                        ),
                        const SizedBox(height: 2),
                        _buildLegendBox(
                          color: const Color.fromARGB(255, 213, 126, 253),
                          text: "Missed",
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                const Divider(height: 10),
                const SizedBox(height: 1),
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
    int totalTaken =
        upcomingReminders.where((reminder) => reminder['isTaken']).length;
    int totalMissed = upcomingReminders.length - totalTaken;

    List<HorizontalDetailsModel> statistics = [
      HorizontalDetailsModel(
          name: 'Taken',
          color: const Color.fromARGB(255, 66, 78, 250),
          size: totalTaken.toDouble()),
      HorizontalDetailsModel(
          name: 'Missed',
          color: const Color.fromARGB(255, 213, 126, 253),
          size: totalMissed.toDouble()),
    ];

    return statistics;
  }

  Widget _buildLegendBox({required Color color, required String text}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4.75,
          backgroundColor: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 9),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
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

DateTime? safeParseDate(String dateString) {
  try {
    List<String> parts = dateString.split('-');
    if (parts.length == 3) {
      String day = parts[0].padLeft(2, '0');
      String month = parts[1].padLeft(2, '0');
      String year = parts[2];
      String formattedDate = '$year-$month-$day';
      return DateTime.parse(formattedDate);
    }
  } catch (e) {
    print("Error parsing date: $e for date string: $dateString");
  }
  return null;
}
