import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
     required String hintext,
     required String labelText,
     IconData? prefixtIcon


  }) {
    return  InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        hintText: hintext,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixtIcon !=null
         ? Icon(
          prefixtIcon,
          color: Colors.deepPurple,
        )  : null
        );
  }
}
