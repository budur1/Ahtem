import 'package:flutter/material.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  _OnboardingScreen1State createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToNextPage() {
    if (_currentPage == 2) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Widget> _buildPages() {
    return [
      _buildPage(
        image: "assest/onboarding1.png",
        title: "Welcome to Ahtem!",
        description: "Your Personal Medication Tracker",
        subtitle:
            "We're here to help you manage your medications and improve your health",
      ),
      _buildPage(
        image: "assest/onboarding2.png",
        title: "Ahtem Works",
        description: "Easy Medication Management",
        subtitle:
            "Enter your medications, set reminders, and track your progress effortlessly.",
      ),
      _buildPage(
        image: "assest/onboarding3.png",
        title: "Get Started",
        description: "Begin Your Health Journey",
        subtitle:
            "Let's get started! Sign up to start tracking your medications and stay on top of your health.",
      ),
    ];
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String description,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 312.14,
          child: Image(
            width: 312.14,
            height: 312.14,
            image: AssetImage(image),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: _buildPages(),
            ),
          ),
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
          Positioned(
            bottom: 30.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: navigateToNextPage,
              child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
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
