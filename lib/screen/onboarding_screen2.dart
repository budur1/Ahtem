import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/screen/onboarding_screen3.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreen2State createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        print("Current Page: $_currentPage");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ensure that PageView is at the bottom of the stack
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: const [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 312.14,
                      child: Image(
                        width: 312.14,
                        height: 312.14,
                        image: AssetImage("assest/onboarding2.png"),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      " Ahtem Works",
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
                      " Enter your medications, set reminders, and track your progress effortlessly.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                // Add other onboarding screens here if needed
              ],
            ),
          ),
          // Skip button
          Positioned(
            top: 40.0,
            right: 20.0,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          // Next button
          Positioned(
            bottom: 30.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnboardingScreen3()));
              },
              child: const Text('Next'),
            ),
          ),

          // Page indicators
          Positioned(
            left: 0,
            right: 0,
            bottom: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3, //  you have 3 onboarding screens
                (index) => Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    color: _currentPage == index
                        ? Colors.black
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
