import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  final String id;
  final String name;
  final List<String> preferredTimes;
  final String dosage;
  final DateTime startDate;
  final int intervalDays;

  Medicine(
      {required this.id,
      required this.name,
      required this.preferredTimes,
      required this.dosage,
      required this.startDate,
      required this.intervalDays});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      preferredTimes: List<String>.from(json['preferredTimes']),
      dosage: json['dosage'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      intervalDays: json['intervalDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'preferredTimes': preferredTimes,
      'dosage': dosage,
      'startDate': startDate,
      'intervalDays': intervalDays,
    };
  }
}
