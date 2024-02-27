import 'package:flutter/material.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(301, 48),
  backgroundColor: const Color.fromRGBO(30, 145, 198, 1),
  textStyle: const TextStyle(color: Colors.white),
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
);
