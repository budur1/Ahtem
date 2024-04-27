import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final DateTime birthDate;
  final String phone;
  final String? sex;

  UserModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.birthDate,
      required this.phone,
      required this.sex});
// This method convert the class instamces into a map, and this map will be used when we need to upload data to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birthDate': Timestamp.fromDate(birthDate),
      'phone': phone,
      'sex': sex
    };
  }

// This static method creates an instance of the class from Firestore documnet map
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        email: map['email'],
        name: map['name'],
        birthDate: (map['birthDate'] as Timestamp).toDate(),
        phone: map['phone'],
        sex: map['sex']);
  }
}

class Medication {
  final String id;
  final DocumentReference userRef;
  final String name;
  final String dosage;
  final List<String> daysOfWeek;
  final int intervalDays;
  final Timestamp startDate;
  final int quantityInCabinet;
  final List<String> preferredTimes;

  Medication(
      {required this.id,
      required this.userRef,
      required this.name,
      required this.dosage,
      required this.daysOfWeek,
      required this.intervalDays,
      required this.startDate,
      required this.quantityInCabinet,
      required this.preferredTimes});
// This method convert the class instamces into a map, and this map will be used when we need to upload data to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userRef': userRef,
      'name': name,
      'dosage': dosage,
      'daysOfWeek': daysOfWeek,
      'intervalDays': intervalDays,
      'startDate': startDate,
      'quantityInCabinet': quantityInCabinet,
      'preferredTimes': preferredTimes
    };
  }

// This static method creates an instance of the class from Firestore documnet map
  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
        id: map['id'],
        userRef: map['userRef'] as DocumentReference,
        name: map['name'],
        dosage: map['dosage'],
        daysOfWeek: List<String>.from(map['daysOfWeek'] ?? []),
        intervalDays: map['intervalDays'] ?? 1,
        startDate: map['startDate'] as Timestamp,
        quantityInCabinet: map['quantityInCabinet'],
        preferredTimes: List<String>.from(map['preferredTimes'] ?? []));
  }
}

class Reminders {
  final String id;
  final DocumentReference userRef;
  final Timestamp dateTaken;
  final DocumentReference medRef;
  final List<Map<String, dynamic>>? takenStatuses;

  Reminders(
      {required this.id,
      required this.userRef,
      required this.dateTaken,
      required this.medRef,
      required this.takenStatuses});
  // This method convert the class instamces into a map, and this map will be used when we need to upload data to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userRef': userRef,
      'dateTaken': dateTaken,
      'medRef': medRef,
      'takenStatuses': takenStatuses
    };
  }

  // This static method creates an instance of the class from Firestore documnet map
  static Reminders fromMap(Map<String, dynamic> map) {
    return Reminders(
      id: map['id'],
      userRef: map['userRef'],
      dateTaken: map['dateTaken'],
      medRef: map['medRef'],
      takenStatuses:
          List<Map<String, dynamic>>.from(map['takenStatuses'] ?? []),
    );
  }
}

class Notifications {
  final String id;
  final DocumentReference userRef;
  final DocumentReference? medRef;
  final String type;
  final String content;
  final Timestamp timestamp;

  Notifications(
      {required this.id,
      required this.userRef,
      this.medRef,
      required this.type,
      required this.content,
      required this.timestamp});
  // This method convert the class instamces into a map, and this map will be used when we need to upload data to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userRef': userRef,
      'medRef': medRef,
      'type': type,
      'content': content,
      'timestamp': timestamp
    };
  }

  // This static method creates an instance of the class from Firestore documnet map
  static Notifications fromMap(Map<String, dynamic> map) {
    return Notifications(
        id: map['id'],
        userRef: map['userRef'],
        medRef: map['medRef'],
        type: map['type'],
        content: map['content'],
        timestamp: map['timestamp']);
  }
}
