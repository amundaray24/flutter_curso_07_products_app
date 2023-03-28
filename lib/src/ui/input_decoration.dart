import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration loginInputDecoration({
    required String hint,
    required String label,
    required IconData icon,
    required Color color
  }) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: color
            )
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: color,
                width: 2
            )
        ),
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(
            color: Colors.grey
        ),
        prefixIcon: Icon(
          icon,
          color: color,
        )
    );
  }

}