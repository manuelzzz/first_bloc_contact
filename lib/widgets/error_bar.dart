import 'package:flutter/material.dart';

class ErrorBar extends SnackBar {
  final String message;

  ErrorBar({
    super.key,
    required this.message,
  }) : super(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
}
