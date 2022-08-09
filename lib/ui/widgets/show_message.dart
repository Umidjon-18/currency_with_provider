import 'package:flutter/material.dart';

import '../../utils/constants.dart';

showMessage(String text,context, {bool isError = true}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green[400],
        content: Text(
          text,
          style: kTextStyle(size: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }