import 'package:flutter/material.dart';

import 'main_form.dart';

abstract class ScheduleField {
  final TextEditingController controller = TextEditingController();
  final FieldsType type;

  ScheduleField(this.type);

  int? _secondsToShutdown(int value);

  int? get seconds {
    final value = int.tryParse(controller.text);
    if (value == null || value < 0) return null;
    return _secondsToShutdown(value);
  }
}

class SecondsField extends ScheduleField {
  SecondsField() : super(FieldsType.seconds);

  @override
  int? _secondsToShutdown(int value) => value;
}

class MinutesField extends ScheduleField {
  MinutesField() : super(FieldsType.minutes);

  @override
  int? _secondsToShutdown(int value) => value * 60;
}

class HoursField extends ScheduleField {
  HoursField() : super(FieldsType.hours);

  @override
  int? _secondsToShutdown(int value) => value * 3600;
}

class DaysField extends ScheduleField {
  DaysField() : super(FieldsType.days);

  @override
  int? _secondsToShutdown(int value) => value * 86400;
}

class DateField extends ScheduleField {
  DateTime? date;

  DateField() : super(FieldsType.date);

  @override
  int? get seconds {
    final date = this.date;
    if (date == null) return null;
    final now = DateTime.now();
    return date.difference(now).inSeconds + 1;
  }

  @override
  int? _secondsToShutdown(int value) => null;
}
