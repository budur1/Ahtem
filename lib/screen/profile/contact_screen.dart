import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.0),
          contactUsItem("Email", "ahtem.application@gmail.com"),
          SizedBox(
            height: 10,
          ),
          contactUsItem("Phone", "+1234567890"),
        ],
      ),
    );
  }

  Widget contactUsItem(String title, String info) {
    return ListTile(
      title: Text(title),
      subtitle: Text(info),
    );
  }
}
