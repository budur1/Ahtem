import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'firebase_options.dart';
import 'screen/profile/profile.dart';
import 'services/local_notification.dart';
import 'package:timezone/data/latest.dart' as tz;

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
  tz.initializeTimeZones();
  await HiveManager().initHive();
  await NotificationService().initializeNotifications();
  scheduleNotificationsFromFirestore();
  rescheduleNotifications();
  NotificationService()
      .scheduleDailyLifestyleNotification(TimeOfDay(hour: 9, minute: 0));
  //testNotification();
  runApp(const MyApp());
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
      setState(() {
        _isUserLoggedIn = user != null;
        _isEmailVerified = user?.emailVerified ?? false;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return GetMaterialApp(
        navigatorKey: navigateKey,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
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
          // '/onboarding2': (context) => const OnboardingScreen2(),
          // '/onboarding3': (context) => const OnboardingScreen3(),
          '/NotificationScreen': (context) => NotificationScreen(),
          '/AddNewMed': (context) => AddNewMedScreen(),
          '/MedList': (context) => MedicationListScreen(),
          '/calendar': (context) => CalendarScreen(),
          '/progress': (context) => ProgressScreen(),
          '/upcoming': (context) => UpcomingRemindersScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      );
    }
  }

  Widget _determineFirstScreen() {
    if (_isUserLoggedIn && _isEmailVerified) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
