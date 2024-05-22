import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  final PageController pageController;

  const OnboardingScreen3({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 312.14,
          child: Image(
            width: 312.14,
            height: 312.14,
            image: AssetImage("assets/onboarding3.png"),
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          "Get Started",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Begin Your Health Journey",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        const Text(
          "Let's get started! Sign up to start tracking your medications and stay on top of your health.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            child: const Text(
              "Let's Get Started",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: "Already have an account?"),
                    TextSpan(
                        text: " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ))
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
