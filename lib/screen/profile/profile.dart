import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medication_reminder_vscode/screen/profile/acc_info_screen.dart';
import 'package:medication_reminder_vscode/screen/profile/help_screen.dart';
import '../../widgets/tabbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _Profile1ScreenState createState() => _Profile1ScreenState();
}

class _Profile1ScreenState extends State<ProfileScreen> {
  int _currentIndex = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ProfileOptions(),
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: CustomTabBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class ProfileOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        profileOption(
          "Account Information",
          Icons.person,
          Icons.arrow_forward,
          subtitle: "Change your Account information",
          onPressed: () {
            Get.to(() => EditProfileScreen());
          },
        ),
        SizedBox(height: 30.0),
        profileOption(
          "Password",
          Icons.remove_red_eye,
          Icons.arrow_forward,
          subtitle: "Change your Password",
          onPressed: () async {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null && user.email != null) {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: user.email!);
                Get.snackbar(
                  'Success',
                  'Check your email for reset instructions.',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'An error occurred while sending reset instructions.',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            } else {
              Get.snackbar(
                'Error',
                'No email associated with this account.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        ),
        SizedBox(height: 30.0),
        profileOption(
          "Help & Support",
          Icons.help,
          Icons.arrow_forward,
          subtitle: "Connect with us",
          onPressed: () {
            Get.to(() => HelpSupportPage());
          },
        ),
        SizedBox(height: 30.0),
        profileOption(
          "Language",
          Icons.language,
          null,
          subtitle: "لتغيير لغة التطبيق الى",
          dropdownOptions: ["English", "Arabic"],
        ),
        SizedBox(height: 30.0),
        profileOption(
          "Logout",
          Icons.exit_to_app,
          null,
          onPressed: () async {
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/onboarding1');
          },
        ),
      ],
    );
  }

  Widget profileOption(
    String title,
    IconData iconLeft,
    IconData? iconRight, {
    String? subtitle,
    List<String>? dropdownOptions,
    VoidCallback? onPressed,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0, right: 16.0),
      leading: Icon(iconLeft),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey),
            )
          : null,
      trailing: iconRight != null
          ? IconButton(
              icon: Icon(iconRight),
              onPressed: onPressed,
            )
          : dropdownOptions != null
              ? DropdownButton<String>(
                  items: dropdownOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    print("Selected language: $value");
                  },
                )
              : null,
      onTap: onPressed,
    );
  }
}
