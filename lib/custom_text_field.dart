import 'package:flutter/material.dart';

class CustomTextField extends TextField {
  const CustomTextField({
    super.controller,
    super.onSubmitted,
    super.focusNode,
    super.inputFormatters,
    super.key,
  }) : super(
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 13.0),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(4),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        );
}
