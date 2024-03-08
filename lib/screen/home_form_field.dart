import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/main_form.dart';
import '../widgets/custom_text_field.dart';

class HomeFormField extends StatefulWidget {
  final MainForm form;

  const HomeFormField(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeFormFieldState();
}

class _HomeFormFieldState extends State<HomeFormField> {
  static const _height = 36.0;

  MainForm get _form => widget.form;

  TextEditingController get _controller => _form.currentField.controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: _height,
            child: CustomTextField(
              labelText: 'Value',
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
