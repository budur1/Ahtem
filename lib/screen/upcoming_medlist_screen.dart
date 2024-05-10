import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/screen/calander_screen.dart';

class UpcomingRemindersScreen extends StatefulWidget {
  final List<ReminderEntry> reminders;

  const UpcomingRemindersScreen({Key? key, required this.reminders})
      : super(key: key);

  @override
  _UpcomingRemindersScreenState createState() =>
      _UpcomingRemindersScreenState();
}

class _UpcomingRemindersScreenState extends State<UpcomingRemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DateandTimePicker()),
            );
            // Handle back arrow press
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Reminders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: widget.reminders,
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderEntry extends StatefulWidget {
  final Color backgroundColor;
  final String medicine;
  final String dosage;
  final String date;
  final Color buttonColor;

  const ReminderEntry({
    Key? key,
    required this.backgroundColor,
    required this.medicine,
    required this.dosage,
    required this.date,
    required this.buttonColor,
  }) : super(key: key);

  @override
  _ReminderEntryState createState() => _ReminderEntryState();
}

class _ReminderEntryState extends State<ReminderEntry> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.medicine,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.black,
                  decoration: isSelected
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                child: Container(
                  width: 36.8,
                  height: 36.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.white,
                    border: Border.all(color: Colors.white),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: widget.backgroundColor,
                        )
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            widget.dosage,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.0),
          Divider(color: Colors.white),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.black),
              SizedBox(width: 8.0),
              Text(
                widget.date,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
