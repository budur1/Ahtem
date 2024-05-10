import 'package:flutter/material.dart';

class MedicationEntry extends StatelessWidget {
  final Color backgroundColor;
  final String medicine;
  final String dosage;
  final String date;
  final String time;
  final Color buttonColor;
  final String buttonText;

  const MedicationEntry({
    Key? key,
    required this.backgroundColor,
    required this.medicine,
    required this.dosage,
    required this.date,
    required this.time,
    required this.buttonColor,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                medicine,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: Colors.black,
                onPressed: () {
                  // Handle edit action
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            dosage,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          const Divider(color: Colors.white),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                ' ${date}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: buttonText == 'Night' || buttonText == 'Evening'
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold, // Changed to white
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
