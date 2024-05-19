import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this import for Get
import 'package:medication_reminder_vscode/DataBase/hive.dart';
import 'package:medication_reminder_vscode/screen/add_medication.dart';
import 'package:medication_reminder_vscode/screen/calander_screen.dart';
import 'package:medication_reminder_vscode/screen/medicationlist_screen.dart';
import 'package:medication_reminder_vscode/screen/notification_screen.dart';
import 'package:medication_reminder_vscode/screen/progress_screen.dart';
import 'package:medication_reminder_vscode/screen/upcoming_medlist_screen.dart';
import 'package:medication_reminder_vscode/services/auth/login.dart';
import 'package:medication_reminder_vscode/screen/home_screen.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen1.dart';
import 'package:medication_reminder_vscode/services/auth/signup.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen2.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen3.dart';
import 'package:medication_reminder_vscode/services/notification_logic.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';
import 'screen/profile/profile.dart';
import 'services/local_notification.dart';

final navigateKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
    return;
  }
//  tz.initializeTimeZones();
  await HiveManager().initHive();
  await NotificationService().initializeNotifications();
  scheduleNotificationsFromFirestore();
  NotificationService()
      .scheduleDailyLifestyleNotification(TimeOfDay(hour: 23, minute: 40));
  //testNotification();
  runApp(const MyApp());
  rescheduleNotifications();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isUserLoggedIn = false;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _isUserLoggedIn = true;
          _isEmailVerified = user.emailVerified;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isUserLoggedIn = false;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else {
      return GetMaterialApp(
        // Use GetMaterialApp instead of MaterialApp
        navigatorKey: navigateKey,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Something went wrong!');
            } else if (snapshot.hasData) {
              return const HomeScreen(); // Navigate to the home screen if the user is logged in
            } else {
              return const LoginScreen(); // Navigate to the login screen if the user is not logged in
            }
          },
        ),
        routes: {
          '/signup': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/homepage': (context) => const HomeScreen(),
          '/onboarding1': (context) => const OnboardingScreen1(),
          '/onboarding2': (context) => const OnboardingScreen2(),
          '/onboarding3': (context) => const OnboardingScreen3(),
          '/NotificationScreen': (context) => NotificationScreen(),
          '/AddNewMed': (context) => AddNewMedScreen(),
          '/MedList': (context) => MedicationListScreen(),
          '/calendar': (context) => CalendarScreen(),
          '/progress': (context) => ProgressScreen(),
          '/upcoming': (context) => UpcomingRemindersScreen(),
          '/profile': (context) => ProfileScreen()
        },
      );
    }
  }

  Widget _determineFirstScreen() {
    // Determines the first screen based on user login and email verification status
    if (_isUserLoggedIn && _isEmailVerified) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
