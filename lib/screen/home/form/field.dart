part of './library.dart';

class HomeFormField extends StatefulWidget {
  final MainForm form;

  const HomeFormField(this.form, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeFormFieldState();
}

class _HomeFormFieldState extends State<HomeFormField> {
  static const _height = 36.0;

  MainForm get _form => widget.form;

  ScheduleField get _currentField => _form.currentField;

  TextEditingController get _controller => _currentField.controller;

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
                MaxSecondsInputFormatter(_currentField),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MaxSecondsInputFormatter extends TextInputFormatter {
  static const int _min = 0;
  final ScheduleField field;

  int get _max => field.maxValue;

  MaxSecondsInputFormatter(this.field);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final num = int.tryParse(newValue.text);
    if (num == null) return oldValue;
    if (num > _max) return oldValue.copyWith(text: '$_max');
    if (num < _min) return oldValue.copyWith(text: '$_min');
    return newValue;
  }
}
