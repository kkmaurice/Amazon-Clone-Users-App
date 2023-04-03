import 'package:flutter/material.dart';

showResuableSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.deepPurple,
    duration: const Duration(seconds: 2),
    content: Text(
      message,
      style: const TextStyle(fontSize: 36, color: Colors.white),
    ),
  ));
}
