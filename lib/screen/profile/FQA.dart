import 'package:flutter/material.dart';

class FqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'F&Q',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          faqItem(
            "How do I create an account?",
            "Go to the Register and write your name, email, and password, then click Let's Get Started and a phrase will appear Thanks",
          ),
          faqItem(
            "How can I reset my password?",
            "Go to the Create New Password page, then enter your new password and click Reset",
          ),
          faqItem(
            "How can I update my profile information?",
            "Through the following link .............",
          ),
          faqItem(
            "How do I change the language settings?",
            "Go to the profile page, choose the language, then choose English or Arabic",
          ),
          faqItem(
            "How can I contact customer support?",
            "Go to the profile page, then choose Help&Support, and three options will appear. Choose Help&Support, and the support email will appear",
          ),
          faqItem(
            "Is my personal information secure?",
            "Yes, and you must set a good and strong password",
          ),
          faqItem(
            "How do I provide feedback or suggest new features?",
            "Through our email: ahtem.application@gmail.com",
          ),
        ],
      ),
    );
  }

  Widget faqItem(String question, String answer) {
    return ListTile(
      title: Text(question),
      subtitle: answer.isNotEmpty ? Text(answer) : null,
    );
  }
}
