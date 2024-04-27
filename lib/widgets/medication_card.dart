import 'package:flutter/material.dart';

class MedicationContainer extends StatefulWidget {
  final String medName;
  final String dosage;
  final String date;
  final String time;
  bool isTaken;

  MedicationContainer({
    Key? key,
    required this.medName,
    required this.dosage,
    required this.date,
    required this.time,
    this.isTaken = false,
  }) : super(key: key);

  @override
  State<MedicationContainer> createState() => _MedicationContainerState();
}

class _MedicationContainerState extends State<MedicationContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isTaken = !widget.isTaken;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(223, 223, 223, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medName,
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.isTaken ? Colors.grey : Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration:
                          widget.isTaken ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.dosage} - ${widget.date} - ${widget.time}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Icon(
                widget.isTaken ? Icons.check_circle : Icons.circle,
                color: widget.isTaken ? Colors.blue : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
