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

  int get maxValue;
}

class SecondsField extends ScheduleField {
  static const _maxValue = 315360000;

  SecondsField() : super(FieldsType.seconds);

  @override
  int? _secondsToShutdown(int value) => value;

  @override
  int get maxValue => _maxValue;
}

class MinutesField extends ScheduleField {
  static const _maxValue = 5256000;

  MinutesField() : super(FieldsType.minutes);

  @override
  int? _secondsToShutdown(int value) => value * 60;

  @override
  int get maxValue => _maxValue;
}

class HoursField extends ScheduleField {
  static const _maxValue = 87600;

  HoursField() : super(FieldsType.hours);

  @override
  int? _secondsToShutdown(int value) => value * 3600;

  @override
  int get maxValue => _maxValue;
}

class DaysField extends ScheduleField {
  static const _maxValue = 3650;

  DaysField() : super(FieldsType.days);

  @override
  int? _secondsToShutdown(int value) => value * 86400;

  @override
  int get maxValue => _maxValue;
}

class DateField extends ScheduleField {
  static const _maxValueInDays = 3650;

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

  @override
  int get maxValue => _maxValueInDays;
}
