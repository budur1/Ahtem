import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:unique_simple_bar_chart/data_models.dart';
import 'package:unique_simple_bar_chart/simple_bar_chart.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final String username = "John";
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hello $username',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 300,
                    width: 343.18, // Set a fixed height for the container
                    padding: const EdgeInsets.all(17),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 1),
                        const Text(
                          'Track your progress over time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 1),
                        const Divider(height: 5),
                        const SizedBox(height: 1),
                        AspectRatio(
                          aspectRatio: 1.3, // Adjust aspect ratio
                          child: SfCartesianChart(
                            margin: const EdgeInsets.all(10), // Adjust margin
                            primaryXAxis: const CategoryAxis(
                              labelStyle:
                                  TextStyle(fontSize: 10), // Increase font size
                            ),
                            primaryYAxis: const NumericAxis(
                              labelPosition: ChartDataLabelPosition
                                  .outside, // Move labels outside
                              labelStyle: TextStyle(
                                fontSize: 10, // Adjust font size
                                color: Colors.black, // Set label color
                              ),
                              minimum: 0,
                              maximum: 60,
                              interval: 20,
                              labelFormat: '{value}%',
                              title: AxisTitle(
                                text: 'Percentage of Doses Taken',
                                textStyle: TextStyle(
                                  fontSize: 10,
                                ), // Increase font size
                              ),
                            ),
                            legend: const Legend(isVisible: false),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            plotAreaBorderWidth: 1,
                            plotAreaBorderColor: Colors.transparent,
                            series: <SplineSeries<SalesData, String>>[
                              SplineSeries<SalesData, String>(
                                color: Colors.red,
                                dataSource: <SalesData>[
                                  SalesData('Jan', 40),
                                  SalesData('Feb', 20),
                                  SalesData('Mar', 50),
                                  SalesData('Apr', 30),
                                  SalesData('May', 20)
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: false),
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
            Container(
              height: 5,
            ),
            const SizedBox(height: 1),
            const Padding(
              padding: EdgeInsets.all(16),
              child: SimpleBarChatScreen(),
            ),
            const SizedBox(height: 1),
            Container(
              height: 300,
              width: 343.18, // Set a fixed height for the container
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.14),
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    "Your Adherence Improved by 72%",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 3),
                  CircularPercentIndicator(
                    radius: 120,
                    lineWidth: 20,
                    percent: 0.72,
                    center: const Text(
                      "72%",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    progressColor: const Color.fromARGB(255, 41, 55, 253),
                    backgroundColor: const Color.fromARGB(255, 230, 228, 228),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _onItemTapped(index);
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    // Implement navigation logic here if needed
  }
}

class SimpleBarChatScreen extends StatelessWidget {
  const SimpleBarChatScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 300,
            width: 343.18,
            padding: const EdgeInsets.all(10),
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
                const Divider(color: Color.fromARGB(255, 185, 182, 182)),
                const SizedBox(height: 1),
                SimpleBarChart(
                  makeItDouble: true,
                  listOfHorizontalBarData: [
                    HorizontalDetailsModel(
                      name: 'Jan',
                      color: const Color.fromARGB(255, 76, 88, 252),
                      size: 19,
                      sizeTwo: 10,
                      colorTwo: const Color.fromARGB(255, 213, 126, 253),
                    ),
                    HorizontalDetailsModel(
                      name: 'Feb',
                      color: const Color.fromARGB(255, 49, 63, 248),
                      size: 20,
                      sizeTwo: 10,
                      colorTwo: const Color.fromARGB(255, 213, 126, 253),
                    ),
                    HorizontalDetailsModel(
                      name: 'Mar',
                      color: const Color.fromARGB(255, 49, 63, 248),
                      size: 30,
                      sizeTwo: 25,
                      colorTwo: const Color.fromARGB(255, 213, 126, 253),
                    ),
                    HorizontalDetailsModel(
                      name: 'Apr',
                      color: const Color.fromARGB(255, 49, 63, 248),
                      size: 9,
                      sizeTwo: 5,
                      colorTwo: const Color.fromARGB(255, 213, 126, 253),
                    ),
                    HorizontalDetailsModel(
                      name: 'May',
                      color: const Color.fromARGB(255, 49, 63, 248),
                      size: 12,
                      sizeTwo: 6,
                      colorTwo: const Color.fromARGB(255, 213, 126, 253),
                    ),
                  ],
                  verticalInterval: 10,
                  horizontalBarPadding: 28,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);
  @override
  State<CustomTabBar> createState() => _TabBarState();
}

class _TabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 12,
      unselectedFontSize: 11,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(color: Colors.black),
      fixedColor: const Color.fromRGBO(239, 72, 132, 1),
      backgroundColor: Colors.grey[200],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: widget.currentIndex,
      onTap: (int newIndex) {
        switch (newIndex) {
          case 0:
            Navigator.pushReplacementNamed(context, '/homepage');
            break;

          case 1:
            Navigator.pushReplacementNamed(context, '/calander');
            break;

          case 2:
            Navigator.pushReplacementNamed(context, '/progress');
            break;

          case 3:
            Navigator.pushReplacementNamed(context, '/NotificationScreen');
            break;

          case 4:
            Navigator.pushReplacementNamed(context, '/profile');
            break;

          default:
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Calendar',
          icon: Icon(Icons.calendar_today),
        ),
        BottomNavigationBarItem(
          label: 'Progress',
          icon: Icon(Icons.pivot_table_chart),
        ),
        BottomNavigationBarItem(
          label: 'Notification',
          icon: Icon(Icons.notification_add),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
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

class SalesData {
  final String year;
  final double sales;

  SalesData(this.year, this.sales);
}
