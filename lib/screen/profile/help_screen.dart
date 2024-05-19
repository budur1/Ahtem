import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medication_reminder_vscode/screen/profile/contact_screen.dart';

import 'FQA.dart';
import 'privacy_policy_screen.dart';

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
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
          helpSupportOption("F&Q", Icons.arrow_forward, () {
            Get.to(() => FqPage());
          }),
          SizedBox(
            height: 10,
          ),
          helpSupportOption("Help & Support", Icons.arrow_forward, () {
            Get.to(() => ContactUsPage());
          }),
          SizedBox(
            height: 10,
          ),
          helpSupportOption("Privacy Policy", Icons.arrow_forward, () {
            Get.to(() => PrivacyPolicyPage());
          }),
        ],
      ),
    );
  }

  Widget helpSupportOption(
      String title, IconData? trailingIcon, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: trailingIcon != null ? Icon(trailingIcon) : null,
      onTap: onTap,
    );
  }
}
