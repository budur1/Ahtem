import 'package:flutter/material.dart';
import 'package:medication_reminder_vscode/services/auth/signup.dart';
import 'package:medication_reminder_vscode/widgets/button_blue.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  _OnboardingScreen3State createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 312.14,
                        child: Image(
                          width: 312.14,
                          height: 312.14,
                          image: AssetImage("assest/onboarding3.png"),
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
                          style: buttonPrimary,
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
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
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
                    ]),
              ],
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: const Text('Next'),
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
