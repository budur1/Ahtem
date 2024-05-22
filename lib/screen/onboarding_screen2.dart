import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  final PageController pageController;

  const OnboardingScreen2({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 312.14,
          child: Image(
            width: 312.14,
            height: 312.14,
            image: AssetImage("assets/onboarding2.png"),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          "Ahtem Works",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Easy Medication Management",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        Text(
          "Enter your medications, set reminders, and track your progress effortlessly.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
