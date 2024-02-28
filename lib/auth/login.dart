import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
// signInWithGoogle fuction

Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  // Once signed in, return the UserCredential
  await FirebaseAuth.instance.signInWithCredential(credential);

  var context;
  Navigator.of(context as BuildContext)
      .pushNamedAndRemoveUntil("HomeScreen", (route) => false);
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  bool isValidEmail(String email) {
    // Regular expression for validating email addresses
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    // Check if the email matches the regular expression pattern
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 43, width: 208),
                  Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22, width: 358),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(30, 145, 198, 1)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      print("Attempting to sign in...");
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (credential.user!.emailVerified) {
                        Navigator.of(context).pushReplacementNamed('/homepage');
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Verify your email',
                          desc:
                              "A varification link has sent to your email account by clicking on the link",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        ).show();
                      }
                    } on FirebaseAuthException catch (e) {
                      print('Authentication error: ${e.message}');
                      String errorMessage = 'An error occurred';
                      if (e.code == 'user-not-found') {
                        errorMessage = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        errorMessage =
                            'Incorrect password. Please check your password.';
                      }
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Authentication Error',
                        desc: errorMessage,
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/signup');
                    },
                    child: const Text(
                      ' Register now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('or Login with'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              signInWithGoogle();
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assest/google.png', // Check the file path
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                16), // Adjust the spacing between the buttons
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Handle Apple login
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assest/apple.png', // Check the file path
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
