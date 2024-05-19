import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          privacyPolicyItem(
            "Information Collection",
            "Details about the information collected from users...",
          ),
          privacyPolicyItem(
            "Data Usage",
            "Explanation of how the collected data is used...",
          ),
          privacyPolicyItem(
            "Data Sharing",
            "Information about data sharing policies...",
          ),
          privacyPolicyItem(
            "User Rights",
            "Details about user rights regarding their data...",
          ),
          privacyPolicyItem(
            "Security Measures",
            "Description of security measures implemented...",
          ),
          privacyPolicyItem(
            "Changes to Privacy Policy",
            "Information about how users will be notified of changes...",
          ),
          privacyPolicyItem(
            "Contact Information",
            "How users can contact support for privacy concerns...",
          ),
        ],
      ),
    );
  }

  Widget privacyPolicyItem(String title, String content) {
    return ListTile(
      title: Text(title),
      subtitle: Text(content),
    );
  }
}
