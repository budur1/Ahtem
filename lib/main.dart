import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/api/notification_service.dart';
import 'package:medication_reminder_vscode/screen/add_medication.dart';
import 'package:medication_reminder_vscode/screen/calander_screen.dart';

import 'package:medication_reminder_vscode/screen/medicationlist_screen.dart';
import 'package:medication_reminder_vscode/screen/notification_screen.dart';
import 'package:medication_reminder_vscode/screen/progress_screen.dart';
import 'package:medication_reminder_vscode/services/auth/login.dart';
import 'package:medication_reminder_vscode/screen/home_screen.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen1.dart';
import 'package:medication_reminder_vscode/services/auth/signup.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen2.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen3.dart';
import 'package:medication_reminder_vscode/services/local_notification.dart';
import 'firebase_options.dart';

final navigateKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotificationService().init(); // Initialize local notifications
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  runApp(const MyApp());
}

void initializeNotifications(BuildContext context) {
  NotificationService service = NotificationService();
  service.requestPermission().then((_) {
    service.subscribeToTopic();
    service.setupInteractions(context);
    service.getFCMToken();
  });
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeNotifications(
          context); // Initialize Firebase notifications after build
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(home: HomeScreen());
      //CircularProgressIndicator()); // Show loading indicator while waiting for authentication
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _determineFirstScreen(),
        onGenerateRoute: (settings) {
          // Dynamic route handling based on notification message
          if (settings.name == '/NotificationScreen') {
            final message = settings.arguments as RemoteMessage;
            return MaterialPageRoute(
              builder: (context) => NotificationScreen(message: message),
            );
          }

          return MaterialPageRoute(builder: (context) {
            switch (settings.name) {
              case '/signup':
                return const RegisterScreen();
              case '/login':
                return const LoginScreen();
              case '/homepage':
                return const HomeScreen();
              case '/onboarding1':
                return const OnboardingScreen1();
              case '/onboarding2':
                return const OnboardingScreen2();
              case '/onboarding3':
                return const OnboardingScreen3();
              case '/AddNewMed':
                return AddNewMedScreen();
              case '/MedList':
                return MedicationListScreen();
              case '/calendar':
                return DateandTimePicker();
              case '/progress':
                return ProgressScreen();
              default:
                return const HomeScreen();
            }
          });
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
