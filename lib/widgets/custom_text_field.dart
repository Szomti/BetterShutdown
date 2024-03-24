import 'package:flutter/material.dart';

import '../app_colors.dart';

class CustomTextField extends TextField {
  CustomTextField({
    String? labelText,
    super.controller,
    super.onSubmitted,
    super.focusNode,
    super.inputFormatters,
    super.key,
  }) : super(
          cursorColor: AppColors().opposite,
          style: TextStyle(
            fontSize: 13.0,
            color: AppColors().text,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: AppColors().text.withOpacity(0.5),
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.all(4).copyWith(left: 8),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors().border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors().border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors().border,
              ),
            ),
          ),
        );
}
