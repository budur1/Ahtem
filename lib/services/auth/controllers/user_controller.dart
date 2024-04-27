import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medication_reminder_vscode/DataBase/data_collection.dart';
import 'dart:core';

//This file contains the UserController class, which provides methods for
//user authentication and data management. It includes functions for signing up
//users with email and password, signing in with Google, and signing out. Additionally,
//it includes a method to save user data to Firestore. This controller facilitates the integration of
//Firebase Authentication and Cloud Firestore with the Flutter application, enabling seamless user management and data storage.

class UserController {
  // SignUp user
  Future<UserModel?> signUpUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Create a new UserModel object
        final userModel = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: '',
          birthDate: DateTime.now(),
          phone: '',
          sex: null,
        );
        // Save the user data to Firestore
        await saveUserData(userModel);
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }

  // SignIn with Google
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_USER',
        message: 'Failed to sign in with Google: Google user is null.',
      );
    }

    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // SignOut
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  // Save user data to Firestore
  Future<void> saveUserData(UserModel user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.id);
    await userDoc.set(user.toMap());
  }

  // this method to display user name, we will use it in the greeting HomeScreen
  Future<String?> getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      } else if (user.email != null && user.email!.isNotEmpty) {
        // If display name is not available, use the email as the username
        return user.email!.split('@').first;
      } else {
        // If neither display name nor email is available, fetch user data from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userData = snapshot.data();
        return userData?['name'] ??
            ''; // Adjust this based on your Firestore structure
      }
    }
    return null;
  }
}
