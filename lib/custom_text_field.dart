import 'package:flutter/material.dart';

class CustomTextField extends TextField {
  CustomTextField({
    String? hintText,
    String? labelText,
    super.controller,
    super.onSubmitted,
    super.focusNode,
    super.inputFormatters,
    super.key,
  }) : super(
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 13.0),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            contentPadding: const EdgeInsets.all(4).copyWith(left: 8),
            border: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        );
}
