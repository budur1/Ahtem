import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/auth/login.dart';
import 'package:medication_reminder_vscode/screen/home_screen.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen1.dart';
import 'package:medication_reminder_vscode/auth/signup.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen2.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen3.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      return const CircularProgressIndicator(); // or any loading widget
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _determineFirstScreen(),
        routes: {
          '/signup': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/homepage': (context) => const HomeScreen(),
          '/onboarding1': (context) => const OnboardingScreen1(),
          '/onboarding2': (context) => const OnboardingScreen2(),
          '/onboarding3': (context) => const OnboardingScreen3(),
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
